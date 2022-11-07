-module (prime_seq).
-export ([start/0, getPrime/0]).
-import (math, [sqrt/1]).
 
generateSelection(List, I, Limit) when I >= Limit -> lists:reverse(List);
generateSelection(List, I, Limit) when I < Limit -> generateSelection([I | List], I + 2, Limit).
 
isPrime(Number, Counter) ->
    if
        (Number rem Counter == 0) -> false;
        (Number rem Counter /= 0) ->
            Limit = sqrt(Number),
            if
                (Counter < Limit) -> isPrime(Number, Counter + 1);
                (Counter >= Limit) -> true
            end
    end.
 
getPrime() ->
    Numbers = generateSelection([], 1, 150000),
    PrimeNumbers = lists:filter(fun(T) -> isPrime(T, 2) end, Numbers),
    lists:nth(10001, PrimeNumbers).

start() ->
    X = getPrime(),
    io:fwrite("~w\n", [X]).