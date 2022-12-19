-module(lex_procs).

-export([find_million_permutation/0, find_million_permutation_by_drop/0]).

-define(PERMUTATION_NUMBER, 1000000).
-define(MAX_PERMUTATION_NUMBER, 4037913).

swap(List, S1, S2) ->
  {List2, [F | List3]} = lists:split(S1 - 1, List),
  LT = List2 ++ [lists:nth(S2, List) | List3],
  {List4, [_ | List5]} = lists:split(S2 - 1, LT),
  List4 ++ [F | List5].


find_suffix(Permutation, I, PrevElement) ->
  CurrentElement = lists:nth(I, Permutation),
  case (I == 1) or (PrevElement > CurrentElement) of
    true -> I;
    false -> find_suffix(Permutation, I - 1, CurrentElement)
  end.


find_suffix_max(Permutation, I, Max) ->
  CurrentElement = lists:nth(I, Permutation),
  case (I == 1) or (Max < CurrentElement) of
    true -> I;
    false -> find_suffix_max(Permutation, I - 1, Max)
  end.


take_permutations(_, _, Acc, I, Limit) when I >= Limit -> lists:reverse(Acc);

take_permutations(GeneratorPid, CurrentPermutation, Acc, I, Limit) when I < Limit ->
  NextPermutation = get_permutation(GeneratorPid, CurrentPermutation),
  take_permutations(GeneratorPid, NextPermutation, [NextPermutation | Acc], I + 1, Limit).


take_permutations(GeneratorPid, CurrentPermutation, Limit) ->
  take_permutations(GeneratorPid, CurrentPermutation, [], 1, Limit).

drop_permutations(_, _, Acc, I, _) when I >= ?MAX_PERMUTATION_NUMBER -> lists:reverse(Acc);

drop_permutations(GeneratorPid, CurrentPermutation, Acc, I, StartI)
when (I >= StartI) and (I < ?MAX_PERMUTATION_NUMBER) ->
  NextPermutation = get_permutation(GeneratorPid, CurrentPermutation),
  drop_permutations(GeneratorPid, NextPermutation, [NextPermutation | Acc], I + 1, StartI);

drop_permutations(GeneratorPid, CurrentPermutation, Acc, I, StartI) when I < StartI ->
  NextPermutation = get_permutation(GeneratorPid, CurrentPermutation),
  drop_permutations(GeneratorPid, NextPermutation, Acc, I + 1, StartI).


drop_permutations(GeneratorPid, CurrentPermutation, Limit) ->
  drop_permutations(GeneratorPid, CurrentPermutation, [], 1, Limit).

generate_next_permutation(Permutation, PermutationSize) ->
  Suffix = find_suffix(Permutation, PermutationSize, lists:nth(PermutationSize, Permutation)),
  Min = find_suffix_max(Permutation, PermutationSize, lists:nth(Suffix, Permutation)),
  {FirstPart, SecondPart} = lists:split(Suffix, swap(Permutation, Suffix, Min)),
  lists:append(FirstPart, lists:sort(SecondPart)).


permutation_generator() ->
  receive
    {SenderPid, get_permutation, CurrentPermutation} ->
      NextPermutation = generate_next_permutation(CurrentPermutation, length(CurrentPermutation)),
      SenderPid ! NextPermutation,
      permutation_generator();

    close -> closed
  end.


create_permutation_generator() -> spawn(fun () -> permutation_generator() end).

close_permutation_generator(GeneratorPid) -> GeneratorPid ! close.

get_permutation(GeneratorPid, Permutation) ->
  GeneratorPid ! {self(), get_permutation, Permutation},
  receive NextPermutation -> NextPermutation after 5000 -> exit(timeout) end.


find_million_permutation() ->
  GeneratorPid = create_permutation_generator(),
  Permutations =
    take_permutations(GeneratorPid, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], ?PERMUTATION_NUMBER),
  close_permutation_generator(GeneratorPid),
  lists:nth(?PERMUTATION_NUMBER - 1, Permutations).


find_million_permutation_by_drop() ->
  GeneratorPid = create_permutation_generator(),
  Permutations =
    drop_permutations(GeneratorPid, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], ?PERMUTATION_NUMBER - 1),
  close_permutation_generator(GeneratorPid),
  lists:nth(1, Permutations).
