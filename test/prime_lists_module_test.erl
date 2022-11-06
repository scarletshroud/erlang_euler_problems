-module (prime_lists_module_test).

-import (prime_lists, [getPrime/0]).

-include_lib("eunit/include/eunit.hrl").

prime_lists_test() ->
    ExpectedResult = 104743,
    ?assertEqual(ExpectedResult, getPrime()).