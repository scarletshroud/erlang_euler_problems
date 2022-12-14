-module(lex_procs).

-export([find_million_permutation/0]).

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


generate_next_permutation(Permutation, PermutationSize) ->
  Suffix = find_suffix(Permutation, PermutationSize, lists:nth(PermutationSize, Permutation)),
  Min = find_suffix_max(Permutation, PermutationSize, lists:nth(Suffix, Permutation)),
  {FirstPart, SecondPart} = lists:split(Suffix, swap(Permutation, Suffix, Min)),
  lists:append(FirstPart, lists:sort(SecondPart)).


take_permutation(GeneratorPid, I, Limit) when I >= Limit - 1 -> next_permutation(GeneratorPid);

take_permutation(GeneratorPid, I, Limit) when I < Limit - 1 ->
  next_permutation(GeneratorPid),
  take_permutation(GeneratorPid, I + 1, Limit).


take_permutation(GeneratorPid, Limit) -> take_permutation(GeneratorPid, 1, Limit).

permutation_generator() ->
  InitialPermutation = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  permutation_generator(InitialPermutation).


permutation_generator(CurrentPermutation) ->
  receive
    {SenderPid, next} ->
      NextPermutation = generate_next_permutation(CurrentPermutation, length(CurrentPermutation)),
      SenderPid ! NextPermutation,
      permutation_generator(NextPermutation);

    close -> closed
  end.


create_permutation_generator() -> spawn(fun () -> permutation_generator() end).

close_permutation_generator(GeneratorPid) -> GeneratorPid ! close.

next_permutation(GeneratorPid) ->
  GeneratorPid ! {self(), next},
  receive NextPermutation -> NextPermutation after 5000 -> exit(timeout) end.


find_million_permutation() ->
  GeneratorPid = create_permutation_generator(),
  Permutations = take_permutation(GeneratorPid, ?PERMUTATION_NUMBER),
  close_permutation_generator(GeneratorPid),
  Permutations.
