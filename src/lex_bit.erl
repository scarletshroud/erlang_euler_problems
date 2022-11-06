-module(lex_bit).
-export([start/0, getPermutation/0]).
 
generateFact(List, I, Acc) when I >= 9 -> lists:reverse([I * Acc | List]);
generateFact(List, I, Acc) when I < 9  -> generateFact([I * Acc | List], I + 1, I * Acc).
 
nextJ(A, K, J, D) ->
    if
        ((A band (1 bsl J)) == 0) ->
            if
                (K == D) -> J;
                true -> nextJ(A, K + 1, J + 1, D)
            end;
        true ->nextJ(A, K, J + 1, D)
    end.
 
permutation(I, _, _, _, Result) when I =< 0 -> lists:reverse(Result);
permutation(I, X, A, Fact, Result) when I > 0 ->
    D = trunc(X / lists:nth(I, Fact)),
    J = nextJ(A, 0, 0, D),
    permutation(I - 1, X - D * lists:nth(I, Fact), A bor (1 bsl J), Fact, [J | Result]).
 
getPermutation() ->
    Fact = generateFact([1, 1], 2, 1),  
    permutation(10, 999999, 0, Fact, []).

start() ->
    Result = getPermutation(),
    io:fwrite("~w~n", [Result]).