-module(dis_store).
-export([explore/1, send/1, register_server/1]).

connect([], _) -> loop();
connect([H|TL], Pid) -> spawn(H, dis_store, register_server, [self()]), connect(TL, Pid).

register_server(Pid) -> register(server, Pid()).

explore(Host) -> {_, L} = net_adm:names(), find_nodes(L, Host), connect(nodes(), self()), loop().

send(Text) -> server ! {daje, Text}.

loop() ->
    receive
        {stop, 0} -> stop;
        {daje, M} -> io:format("~p~n", [M]), loop()
    end.

find_nodes([], _) -> ok;
find_nodes([H|TL], Host) -> {Name, _} = H, 
    net_adm:ping(list_to_atom(Name++"@"++atom_to_list(Host))), find_nodes(TL, Host).