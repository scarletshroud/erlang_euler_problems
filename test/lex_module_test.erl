-module (lex_module_test).
-export ([lexModuleTest/0]).

-import (lex, [getPermutation/0]).

-include_lib("eunit/include/eunit.hrl").

lexModuleTest() ->
    ExpectedResult = [2,7,8,3,9,1,5,4,6,0],
    ?assertEqual(ExpectedResult, getPermutation()).