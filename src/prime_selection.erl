-module (prime_selection).
-export ([start/0, getPrimeFromSelection/0]).
-import (math, [sqrt/1]).
 
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

start() -> io:fwrite("~w\n", [getPrimeFromSelection()]).