-module(es2_store).
-export([start/1, store/2, lookup/1, close/0]).

close() -> server ! {basta, stop}.

start(Node) -> put(server, spawn(Node, fun() -> loop() end)).

store(Tag, Value) -> rpc({store, Tag, Value}).

lookup(Tag) -> rpc({lookup, Tag}).
    
rpc(Message) -> get(server) ! {Message, self()},
    receive
        {store, _} -> ok;
        {lookup, Tag, Response} -> io:format("~p: ~p~n", [Tag, Response])
    end.

loop() ->
    receive
        {{store, Tag, Value}, From} -> put(Tag, Value), From ! {store, ok}, loop();
        {{lookup, Tag}, From} -> From ! {lookup, Tag, get(Tag)}, loop();
        {basta, stop} -> exit(male)
    end.