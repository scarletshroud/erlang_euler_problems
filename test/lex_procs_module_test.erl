-module (lex_procs_module_test).

-import (lex_procs, [getPermutation/0]).

-include_lib("eunit/include/eunit.hrl").

lex_procs_test() ->
    ExpectedResult = [4, 3, 2, 1],
    ?assertEqual(ExpectedResult, getPermutation()).