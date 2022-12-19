-module(modules_test).

-import(prime, [getPrime/0]).
-import(prime_divisors, [getPrimeByListOfDivisors/0]).
-import(prime_selection, [getPrimeFromSelection/0]).
-import(lex, [getPermutation/0]).
-import(lex_bit, [getPermutationByBitOperations/0]).
-import(lex_next, [getPermutationByCurrent/0]).
-import(lex_procs, [find_million_permutation/0, find_million_permutation_by_drop/0]).

-include_lib("eunit/include/eunit.hrl").

prime_task_test() ->
  ExpectedResult = 104743,
  ?assertEqual(ExpectedResult, getPrime()),
  ?assertEqual(ExpectedResult, getPrimeByListOfDivisors()),
  ?assertEqual(ExpectedResult, getPrimeFromSelection()).


lex_next_test() ->
  ExpectedResult = [2, 7, 8, 3, 9, 1, 5, 4, 6, 0],
  ?assertEqual(ExpectedResult, getPermutation()),
  ?assertEqual(ExpectedResult, getPermutationByBitOperations()),
  ?assertEqual(ExpectedResult, getPermutationByCurrent()),
  ?assertEqual(ExpectedResult, find_million_permutation()).
