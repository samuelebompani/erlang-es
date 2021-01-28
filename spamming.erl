-module(spamming).
-export([explore/0, send_msg/1, print_msg/1]).

send_msg(M) -> 
    Host = [list_to_atom(net_adm:localhost())],
    send_msg(net_adm:world_list(Host), M).
send_msg([], _) -> done;
send_msg([H|TL], M) -> spawn(H, spamming, print_msg, [M]), send_msg(TL, M).

print_msg(M) -> io:format(user, M, []).

%I won't use explore/0 because I implemented it before I found net_adm:world_list/0.
%The same result can be obtained with net_adm:world(), if the .hosts.erlang file contains the hosts names.
explore() ->
    {_, Names} = net_adm:names(), Host = net_adm:localhost(),
    L = lists:map(fun(X) -> {N, _} = X, list_to_atom(N++"@"++Host) end, Names),
    lists:foreach(fun(X) -> net_adm:ping(X) end, L).

