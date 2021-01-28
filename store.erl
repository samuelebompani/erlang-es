-module(store).
-export([start/1, store/2, lookup/1, stop/0]).

start(Host) -> 
    ping_all(Host),
    global:register_name(store, spawn(fun() -> loop(dict:new()) end)).

store(Tag, Value) -> rpc({store, Tag, Value}).

lookup(Tag) -> rpc({lookup, Tag}).

stop() -> rpc({stop, 0}).
    
rpc(Message) -> global:whereis_name(store) ! {Message, self()},
    receive
        {store, _} -> io:format("Ok, stored~n");
        {lookup, Tag, {ok, Response}} -> io:format("~p: ~p~n", [Tag, Response]);
        {lookup, Tag, _} -> io:format("ERROR, ~p not found~n", [Tag]);
        {stop, ok} -> ok;
        Other -> io:format("ERROR ~p~n", [Other])
    end.

loop(D) ->
    receive
        {{store, Tag, Value}, Pid} -> io:format("~p stored <~p ~p>~n", [Pid, Tag, Value]), Pid ! {store, 0}, loop(dict:store(Tag, Value, D));
        {{lookup, Tag}, Pid} -> io:format("~p asked for ~p~n", [Pid, Tag]), Ret = dict:find(Tag, D), Pid ! {lookup, Tag, Ret}, loop(D);
        {{stop, 0}, Pid} -> io:format("Stopped~n"), Pid ! {stop, ok}
    end.

ping_all(Host) -> lists:foreach(fun(X) -> net_adm:ping(X) end, net_adm:world_list([Host])).