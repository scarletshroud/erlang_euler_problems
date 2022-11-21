-module(lex_procs).

-export([nextPermutation/0, start/0, getPermutationFromProc/0]).

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


nextPermutation() ->
  receive
    {From, Numbers, Size} ->
      Suffix = findSuffix(Numbers, Size, lists:nth(Size, Numbers)),
      Min = findSuffixMax(Numbers, Size, lists:nth(Suffix, Numbers)),
      {FirstPart, SecondPart} = lists:split(Suffix, swap(Numbers, Suffix, Min)),
      From ! lists:append(FirstPart, lists:sort(SecondPart)),
      nextPermutation();

    Other ->
      io:format("*I don't know what the area of a ~p is ~n*", [Other]),
      nextPermutation()
  after
    1000 -> io:format("Server didn't respond.")
  end.


findPermutation(Pid, Numbers, Size, I, Limit) ->
  case I of
    (Limit) -> Numbers;

    (_) ->
      Pid ! {self(), Numbers, Size},
      receive
        Response -> findPermutation(Pid, Response, Size, I + 1, Limit)
      after
        1000 -> io:format("Client didn't respond.")
      end
  end.


getPermutationFromProc() ->
  Pid = spawn(fun () -> nextPermutation() end),
  findPermutation(Pid, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 1, 1000000).


start() -> io:fwrite("~w~n", [getPermutationFromProc()]).
