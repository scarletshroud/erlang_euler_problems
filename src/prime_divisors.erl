-module(prime_divisors).

-export([start/0, getPrimeByListOfDivisors/0]).

-import(math, [sqrt/1]).
-import(lists, [any/2]).

generatePossibleDivisors(List, I, Limit) when I >= Limit + 1 -> lists:reverse(List);

generatePossibleDivisors(List, I, Limit) when I < Limit + 1 ->
  generatePossibleDivisors([I | List], I + 1, Limit).

isNotPrime(Number) ->
  PossibleDivisors = generatePossibleDivisors([2], 3, round(sqrt(Number))),
  lists:any(
    fun
      (T) ->
        case Number rem T of
          (0) -> true;
          (_) -> false
        end
    end,
    PossibleDivisors
  ).


findPrime(Number, 10001) -> Number - 2;

findPrime(Number, I) ->
  case isNotPrime(Number) of
    (true) -> findPrime(Number + 2, I);
    (false) -> findPrime(Number + 2, I + 1)
  end.


getPrimeByListOfDivisors() -> findPrime(3, 1).

start() -> io:fwrite("~w\n", [getPrimeByListOfDivisors()]).
