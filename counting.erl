-module(counting).
-export([start/0, pizza/1, pasta/1, risotto/1, zuppa/1, tot/0, stop/0]).

start() -> Pid = spawn(fun() -> loop([]) end),
    register(server, Pid), link(Pid).

pizza(N) -> server ! {pizza, N}.
pasta(N) -> server ! {pasta, N}.
risotto(N) -> server ! {risotto, N}.
zuppa(N) -> server ! {zuppa, N}.
tot() -> server ! {tot, 1}.
stop() -> exit(we).

loop(List) ->
    receive
        {pizza, N} -> io:format("pizza: ~p~n", [N]), loop(update(List,[], pizza, N));
        {pasta, N} -> io:format("pasta: ~p~n", [N]), loop(update(List,[], pasta, N));
        {risotto, N} -> io:format("risotto: ~p~n", [N]), loop(update(List,[], risotto, N));
        {zuppa, N} -> io:format("zuppa: ~p~n", [N]), loop(update(List,[], zuppa, N));
        {tot, _} -> spawn(fun() -> print_list(List, 0) end), loop(List)
    end.

print_list([], T) -> io:format("Totale ordini: ~p~n", [T]);
print_list([{C, Q}|TL], T) -> io:format("~p: ~p~n", [C,Q]), print_list(TL, T+Q).

update([], L2, Command, Quantity) -> [{Command, Quantity} | L2];
update([{C, Q} | TL], L2, Command, Quantity) when C==Command -> lists:append([{C, Q+Quantity}| TL], L2);
update([H | TL], L2, Command, Quantity) -> update(TL, [H | L2], Command, Quantity).