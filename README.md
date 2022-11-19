erlang euler problems
=====

### First problem

By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
What is the 10 001st prime number?

### Modular implementation of the algorithm using tail recursion
```erlang
isPrime(Number) -> isPrime(Number, 2).
isPrime(Number, Counter) ->
    case Number rem Counter of 
        (0) -> false;
        (_) ->
            Limit = sqrt(Number),
            if 
                (Counter < Limit) -> isPrime(Number, Counter + 1);
                (Counter >= Limit) -> true
            end
    end.
 
findPrime(Number, 10001) -> Number - 2;
findPrime(Number, Counter) ->
    case isPrime(Number) of
        (true) -> findPrime(Number + 2, Counter + 1);
        (false) -> findPrime(Number + 2, Counter)
    end.

getPrime() -> findPrime(3, 1).
```

### Modular implementations of the algorithm using list filtering.
###### Sample Based
```erlang
generateSelection(List, I, Limit) when I >= Limit -> lists:reverse(List);
generateSelection(List, I, Limit) when I < Limit -> generateSelection([I | List], I + 2, Limit).
 
isPrime(Number, Counter) ->
    case Number rem Counter of
        (0) -> false;
        (_) ->
            Limit = sqrt(Number),
            if
                (Counter < Limit) -> isPrime(Number, Counter + 1);
                (Counter >= Limit) -> true
            end
    end.
 
getPrimeFromSelection() ->
    Numbers = generateSelection([], 1, 150000),
    PrimeNumbers = lists:filter(fun(T) -> isPrime(T, 2) end, Numbers),
    lists:nth(10001, PrimeNumbers).
```

###### Based on a sample of divisors
```erlang
generatePossibleDivisors(List, I, Limit) when I >= Limit + 1 -> lists:reverse(List);
generatePossibleDivisors(List, I, Limit) when I < Limit + 1 -> generatePossibleDivisors([I | List], I + 1, Limit).
 
isNotPrime(Number) ->
    PossibleDivisors = generatePossibleDivisors([2], 3, round(sqrt(Number))),
    lists:any(
        fun(T) ->
            case Number rem T of
                (0) -> true;
                (_) -> false
            end
        end,
    PossibleDivisors).
 
findPrime(Number, 10001) -> Number - 2;
findPrime(Number, I) ->
    case isNotPrime(Number) of
        (true)  -> findPrime(Number + 2, I);
        (false) -> findPrime(Number + 2, I + 1)
    end.

getPrimeByListOfDivisors() -> findPrime(3, 1).
```

### Second problem

A permutation is an ordered arrangement of objects. For example, 3124 is one possible permutation of the digits 1, 2, 3 and 4. If all of the permutations are listed numerically or alphabetically, we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:

012   021   102   120   201   210

What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?

### Method based on the selection of numbers for sequence generation
```erlang
generateFact(List, I, Acc) when I >= 9 -> [I * Acc | List];
generateFact(List, I, Acc) when I < 9  -> generateFact([I * Acc | List], I + 1, I * Acc).
 
nextDigit(Numbers, Fact, I, FactI, Limit) ->
    Amount = I * lists:nth(FactI, Fact),
    if  
        (Amount >= Limit) -> {I - 1, lists:nth(I, Numbers)};
        (Amount < Limit) ->
            case length(Numbers) of
                (1) -> {I, lists:nth(I, Numbers)};
                (_) -> nextDigit(Numbers, Fact, I + 1, FactI, Limit)
            end
    end.
 
permutation(_, _, Result, I, _, _) when I > 10 -> lists:reverse(Result);
permutation(Numbers, Fact, Result, I, FactI, Limit) when I =< 10 ->
    Digit = nextDigit(Numbers, Fact, 1, FactI, Limit),
    permutation(lists:delete(element(2, Digit), Numbers), Fact, [element(2, Digit) | Result], I + 1, FactI + 1, Limit - lists:nth(FactI, Fact) * element(1, Digit)).

getPermutation() ->
    Fact = generateFact([1, 1], 2, 1),
    permutation([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], Fact, [], 1, 1, 1000000).
```

### Method using bit operations
```erlang
generateFact(List, I, Acc) when I >= 9 -> lists:reverse([I * Acc | List]);
generateFact(List, I, Acc) when I < 9  -> generateFact([I * Acc | List], I + 1, I * Acc).
 
nextJ(A, K, J, D) ->
    case (A band (1 bsl J)) of 
        (0) ->
            case K of 
                (D) -> J;
                (_) -> nextJ(A, K + 1, J + 1, D)
            end;
        (_) ->nextJ(A, K, J + 1, D)
    end.
 
permutation(I, _, _, _, Result) when I =< 0 -> lists:reverse(Result);
permutation(I, X, A, Fact, Result) when I > 0 ->
    D = trunc(X / lists:nth(I, Fact)),
    J = nextJ(A, 0, 0, D),
    permutation(I - 1, X - D * lists:nth(I, Fact), A bor (1 bsl J), Fact, [J | Result]).
 
getPermutationByBitOperations() -> permutation(10, 999999, 0, generateFact([1, 1], 2, 1), []).
```

### Method for generating the next sequence based on the current one
```erlang
swap(List, S1, S2) -> 
    {List2, [F | List3]} = lists:split(S1 - 1, List),
    LT = List2++[lists:nth(S2, List) | List3],
    {List4, [_ | List5]} = lists:split(S2 - 1, LT),
    List4++[F | List5].

findSuffix(Numbers, I, PrevElement) ->
    CurrentElement = lists:nth(I, Numbers),
    if 
        (I == 1) or (PrevElement > CurrentElement) -> I;
        (PrevElement =< CurrentElement) -> findSuffix(Numbers, I - 1, CurrentElement)
    end.

findSuffixMax(Numbers, I, Max) ->
    CurrentElement = lists:nth(I, Numbers), 
    if
        (I == 1) or (Max < CurrentElement) -> I;
        (Max >= CurrentElement) -> findSuffixMax(Numbers, I - 1, Max)
    end. 

nextPermutation(Numbers, Size) ->
    Suffix = findSuffix(Numbers, Size, lists:nth(Size, Numbers)),
    Min = findSuffixMax(Numbers, Size, lists:nth(Suffix, Numbers)),
    {FirstPart, SecondPart} = lists:split(Suffix, swap(Numbers, Suffix, Min)),
    lists:append(FirstPart, lists:sort(SecondPart)).

findPermutation(Numbers, Size, I, Limit) ->
    case I of  
        (Limit) -> Numbers;
        (_) -> findPermutation(nextPermutation(Numbers, Size), Size, I + 1, Limit)
    end.

getPermutationByCurrent() -> findPermutation([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 1, 1000000).
```

### The previous implementation but now using an additional process to generate the next sequence
```erlang
swap(List, S1, S2) -> 
    {List2, [F | List3]} = lists:split(S1 - 1, List),
    LT = List2++[lists:nth(S2, List) | List3],
    {List4, [_ | List5]} = lists:split(S2 - 1, LT),
    List4++[F | List5].

findSuffix(Numbers, I, PrevElement) ->
    CurrentElement = lists:nth(I, Numbers),
    if 
        (I == 1) or (PrevElement > CurrentElement) -> I;
        (PrevElement =< CurrentElement) -> findSuffix(Numbers, I - 1, CurrentElement)
    end.

findSuffixMax(Numbers, I, Max) ->
    CurrentElement = lists:nth(I, Numbers), 
    if
        (I == 1) or (Max < CurrentElement) -> I;
        (Max >= CurrentElement) -> findSuffixMax(Numbers, I - 1, Max)
    end. 

nextPermutation() ->
    receive
        {From, Numbers, Size} -> 
            Suffix = findSuffix(Numbers, Size, lists:nth(Size, Numbers)),
            Min = findSuffixMax(Numbers, Size, lists:nth(Suffix, Numbers)),
            {FirstPart, SecondPart} = lists:split(Suffix, swap(Numbers, Suffix, Min)),
            From ! lists:append(FirstPart, lists:sort(SecondPart)),
            nextPermutation();
        Other -> 
            io:format("*I don't know what the area of a ~p is ~n*", [Other]),
            nextPermutation()
    after 1000 -> io:format("Server didn't respond.")
    end.    

findPermutation(Pid, Numbers, Size, I, Limit) ->
    case I of  
        (Limit) -> Numbers;
        (_) -> 
            Pid ! {self(), Numbers, Size},
            receive
                Response -> findPermutation(Pid, Response, Size, I + 1, Limit)
            after 1000 -> io:format("Client didn't respond.")
            end
    end.

getPermutationFromProc() -> 
    Pid = spawn(fun() -> nextPermutation() end),
    findPermutation(Pid, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 1, 1000000).
```

