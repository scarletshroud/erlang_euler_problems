-module (prime_seq_module_test).

-export ([primeSeqModuleTest/0]).

-import (prime_seq, [getPrime/0]).

-include_lib("eunit/include/eunit.hrl").

primeSeqModuleTest() ->
    ExpectedResult = 104743,
    io:fwrite("Prime Sequence Module Test Result ~s\n", ?assertEqual(ExpectedResult, getPrime())).
