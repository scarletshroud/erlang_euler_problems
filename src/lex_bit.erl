-module(lex_bit).
-export([start/0, getPermutationByBitOperations/0]).
 
generateFact(List, I, Acc) when I >= 9 -> lists:reverse([I * Acc | List]);
generateFact(List, I, Acc) when I < 9  -> generateFact([I * Acc | List], I + 1, I * Acc).
 
nextJ(A, K, J, D) ->
    case (A band (1 bsl J)) of 
        (0) ->
            case K of 
                (D) -> J;
                (_) -> nextJ(A, K + 1, J + 1, D)
            end;
        (_) ->nextJ(A, K, J + 1, D)
    end.
 
permutation(I, _, _, _, Result) when I =< 0 -> lists:reverse(Result);
permutation(I, X, A, Fact, Result) when I > 0 ->
    D = trunc(X / lists:nth(I, Fact)),
    J = nextJ(A, 0, 0, D),
    permutation(I - 1, X - D * lists:nth(I, Fact), A bor (1 bsl J), Fact, [J | Result]).
 
getPermutationByBitOperations() -> permutation(10, 999999, 0, generateFact([1, 1], 2, 1), []).

start() -> io:fwrite("~w~n", [getPermutationByBitOperations()]).