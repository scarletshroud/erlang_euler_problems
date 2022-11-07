-module (prime_lists).
-export ([start/0, getPrime/0]).
-import (math, [sqrt/1]).
-import (lists, [any/2]).
 
generatePossibleDivisors(List, I, Limit) when I >= Limit + 1 -> lists:reverse(List);
generatePossibleDivisors(List, I, Limit) when I < Limit + 1 -> generatePossibleDivisors([I | List], I + 1, Limit).
 
isNotPrime(Number) ->
    PossibleDivisors = generatePossibleDivisors([2], 3, round(sqrt(Number))),
    lists:any(
        fun(T) ->
            if
                (Number rem T /= 0) -> false;
                (Number rem T == 0) -> true
            end
        end,
    PossibleDivisors).
 
findPrime(Number, 10001) -> Number - 2;
findPrime(Number, I) ->
    Prime = isNotPrime(Number),
    if
        (Prime == true) -> findPrime(Number + 2, I);
        (Prime == false) -> findPrime(Number + 2, I + 1)
    end.

getPrime() ->
    findPrime(3, 1).

start() ->
    X = getPrime(),
    io:fwrite("~w\n", [X]).