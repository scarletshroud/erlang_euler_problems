-module(lex).
-export([start/0, getPermutation/0]).
 
generateFact(List, I, Acc) when I >= 9 -> [I * Acc | List];
generateFact(List, I, Acc) when I < 9  -> generateFact([I * Acc | List], I + 1, I * Acc).
 
nextDigit(Numbers, Fact, I, FactI, Limit) ->
    Amount = I * lists:nth(FactI, Fact),
    if  
        (Amount >= Limit) -> {I - 1, lists:nth(I, Numbers)};
        (Amount < Limit) ->
            if 
                (length(Numbers) == 1) -> {I, lists:nth(I, Numbers)};
                (length(Numbers) /= 1) -> nextDigit(Numbers, Fact, I + 1, FactI, Limit)
            end
    end.
 
permutation(_, _, Result, I, _, _) when I > 10 -> lists:reverse(Result);
permutation(Numbers, Fact, Result, I, FactI, Limit) when I =< 10 ->
    Digit = nextDigit(Numbers, Fact, 1, FactI, Limit),
    permutation(lists:delete(element(2, Digit), Numbers), Fact, [element(2, Digit) | Result], I + 1, FactI + 1, Limit - lists:nth(FactI, Fact) * element(1, Digit)).

getPermutation() ->
    Numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    Fact = generateFact([1, 1], 2, 1),
    permutation(Numbers, Fact, [], 1, 1, 1000000).

start() ->
    Result = getPermutation(),
    io:fwrite("~w~n", [Result]).