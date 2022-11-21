-module(lex_next).

-export([start/0, getPermutationByCurrent/0]).

swap(List, S1, S2) ->
  {List2, [F | List3]} = lists:split(S1 - 1, List),
  LT = List2 ++ [lists:nth(S2, List) | List3],
  {List4, [_ | List5]} = lists:split(S2 - 1, LT),
  List4 ++ [F | List5].


findSuffix(Numbers, I, PrevElement) ->
  CurrentElement = lists:nth(I, Numbers),
  case (I == 1) or (PrevElement > CurrentElement) of
    true -> I;
    false -> findSuffix(Numbers, I - 1, CurrentElement)
  end.


findSuffixMax(Numbers, I, Max) ->
  CurrentElement = lists:nth(I, Numbers),
  case (I == 1) or (Max < CurrentElement) of
    true -> I;
    false -> findSuffixMax(Numbers, I - 1, Max)
  end.


nextPermutation(Numbers, Size) ->
  Suffix = findSuffix(Numbers, Size, lists:nth(Size, Numbers)),
  Min = findSuffixMax(Numbers, Size, lists:nth(Suffix, Numbers)),
  {FirstPart, SecondPart} = lists:split(Suffix, swap(Numbers, Suffix, Min)),
  lists:append(FirstPart, lists:sort(SecondPart)).


findPermutation(Numbers, Size, I, Limit) ->
  case I of
    (Limit) -> Numbers;
    (_) -> findPermutation(nextPermutation(Numbers, Size), Size, I + 1, Limit)
  end.


getPermutationByCurrent() -> findPermutation([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 1, 1000000).

start() -> io:fwrite("~w~n", [getPermutationByCurrent()]).
