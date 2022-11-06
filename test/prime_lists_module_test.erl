-module (prime_lists_module_test).

-export ([primeListsModuleTest/0]).

-import (prime_lists, [getPrime/0]).

-include_lib("eunit/include/eunit.hrl").

primeListsModuleTest() ->
    ExpectedResult = 104743,
    ?assertEqual(ExpectedResult, getPrime()).