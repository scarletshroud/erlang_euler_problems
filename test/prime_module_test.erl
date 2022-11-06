-module (prime_module_test).

-import (prime, [getPrime/0]).

-include_lib("eunit/include/eunit.hrl").

prime_test() -> 
    ExpectedResult = 104743, 
    ?assertEqual(ExpectedResult, getPrime()).