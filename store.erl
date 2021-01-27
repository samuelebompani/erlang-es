-module(store).
-compile(export_all).

start(Host) -> {_, L} = net_adm:names(), find_nodes(L, Host),
    put(store, spawn(fun() -> loop() end)).

print() -> io:format("~w", [nodes()]).

store(Tag, Value) -> rpc({store, Tag, Value}).

lookup(Tag) -> rpc({lookup, Tag}).
    
rpc(Message) -> get(store) ! {Message, self()},
    receive
        {store, _} -> ok;
        {lookup, Tag, Response} -> io:format("~p: ~p~n", [Tag, Response])
    end.

loop() ->
    receive
        {{store, Tag, Value}, Pid} -> io:format("~p: ~p~n", [Tag, Value]), Pid ! {store, 0}, loop();
        {{lookup, Tag}, Pid} -> Pid ! {lookup, Tag, 10}, loop()
    end.

find_nodes([], _) ->  ok;
find_nodes([H|TL], Host) -> {Name, _} = H,
    net_adm:ping(list_to_atom(Name++"@"++atom_to_list(Host))),
    find_nodes(TL, Host).