-module (prime_module_test).

-export ([primeModuleTest/0]).

-import (prime, [getPrime/0]).

-include_lib("eunit/include/eunit.hrl").

primeModuleTest() -> 
    ExpectedResult = 104743, 
    ?assertEqual(ExpectedResult, getPrime()).