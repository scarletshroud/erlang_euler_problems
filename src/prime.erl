-module (prime).
-export ([start/0, getPrime/0]).
-import (math, [sqrt/1]).
 
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

start() -> io:fwrite("~w\n", [findPrime(3, 1)]).