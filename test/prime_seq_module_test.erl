-module (prime_seq_module_test).


-import (prime_seq, [getPrime/0]).

-include_lib("eunit/include/eunit.hrl").

prime_seq_test() ->
    ExpectedResult = 104743,
    ?assertEqual(ExpectedResult, getPrime()).
