-module (prime).
-export ([start/0, getPrime/0]).
-import (math, [sqrt/1]).
 
isPrime(Number) -> isPrime(Number, 2).
isPrime(Number, Counter) ->
    if
        (Number rem Counter == 0) -> false;
        (Number rem Counter /= 0) ->
            Limit = sqrt(Number),
            if 
                Counter < Limit -> isPrime(Number, Counter + 1);
                Counter >= Limit -> true
            end
    end.
 
findPrime(Number, 10001) -> Number - 2;
findPrime(Number, Counter) ->
    Prime = isPrime(Number),
    if
        (Prime == true) -> findPrime(Number + 2, Counter + 1);
        (Prime == false) -> findPrime(Number + 2, Counter)
    end.

getPrime() -> findPrime(3, 1).

start() ->
    X = findPrime(3, 1),
    io:fwrite("~w\n", [X]).