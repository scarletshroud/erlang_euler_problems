-module (lex_next_module_test).
-export ([lexNextModuleTest/0]).

-import (lex_next, [getPermutation/0]).

-include_lib("eunit/include/eunit.hrl").

lexNextModuleTest() ->
    ExpectedResult = [2,7,8,3,9,1,5,4,6,0],
    ?assertEqual(ExpectedResult, getPermutation()).