-module (lex_bit_module_test).

-import (lex_bit, [getPermutation/0]).

-include_lib("eunit/include/eunit.hrl").

lex_bit_test() ->
    ExpectedResult = [2,7,8,3,9,1,5,4,6,0],
    ?assertEqual(ExpectedResult, getPermutation()).