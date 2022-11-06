-module (lex_next_module_test).

-import (lex_next, [getPermutation/0]).

-include_lib("eunit/include/eunit.hrl").

lex_next_test() ->
    ExpectedResult = [4, 3, 2, 1],
    ?assertEqual(ExpectedResult, getPermutation()).