-module (lex_procs_module_test).

-import (lex_procs, [getPermutation/0]).

-include_lib("eunit/include/eunit.hrl").

lex_procs_test() ->
    ExpectedResult = [2,7,8,3,9,1,5,4,6,0],
    ?assertEqual(ExpectedResult, getPermutation()).