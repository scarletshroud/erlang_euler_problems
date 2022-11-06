-module(lex_procs).
-export([nextPermutation/0, start/0, getPermutation/0]).

swap(List, S1, S2) -> 
    {List2, [F | List3]} = lists:split(S1 - 1, List),
    LT = List2++[lists:nth(S2, List) | List3],
    {List4, [_ | List5]} = lists:split(S2 - 1, LT),
    List4++[F | List5].

findSuffix(Numbers, I, PrevElement) ->
    CurrentElement = lists:nth(I, Numbers),
    if 
        (I == 1) -> I + 1;
        (PrevElement > CurrentElement) -> I;
        (PrevElement =< CurrentElement) -> findSuffix(Numbers, I - 1, CurrentElement)
    end.

findMin(Numbers, I, Max) ->
    CurrentElement = lists:nth(I, Numbers), 
    if
        (I == 1) -> I;
        (Max < CurrentElement) -> I;
        (Max >= CurrentElement) -> findMin(Numbers, I - 1, Max)
    end. 

nextPermutation() ->
    receive
        {From, Numbers, Size} -> 
            Suffix = findSuffix(Numbers, Size, lists:nth(Size, Numbers)),
            Min = findMin(Numbers, Size, lists:nth(Suffix, Numbers)),
            NewList = swap(Numbers, Suffix, Min),
            {FirstPart, SecondPart} = lists:split(Suffix, NewList),
            From ! lists:append(FirstPart, lists:sort(SecondPart)),
            nextPermutation();
        Other -> 
            io:format("*I don't know what the area of a ~p is ~n*", [Other]),
            nextPermutation()
    end.    

findPermutation(Pid, Numbers, I, Limit) ->
    if 
        (I == Limit) -> Numbers;
        (I < Limit) -> 
            Pid ! {self(), Numbers, 4},
            receive
                Response -> findPermutation(Pid, Response, I + 1, Limit)
            end
    end.

getPermutation() -> 
    Numbers = [1, 2, 3, 4],
    Pid = spawn(fun() -> nextPermutation() end),
    findPermutation(Pid, Numbers, 1, 24).

start() ->
    Result = getPermutation(),
    io:fwrite("~w~n", [Result]).