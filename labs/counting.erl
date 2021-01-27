-module(counting).
-export([start/0, pizza/1, pasta/1, risotto/1, zuppa/1, tot/0, stop/0]).

%Write a module counting which provides the functionality for interacting with a 
%server that counts how many times its services has been requested.
%It has to implement several services dummy1, ... dummyn (doesn't matter what they do or their real interface)
%and a service tot that returns a list of records indexed on each service (tot included)
%containing also how many times such a service has been requested.
%Test it from the shell.

start() -> Pid = spawn(fun() -> loop(dict:new()) end),
    register(server, Pid), link(Pid).

pizza(N) -> server ! {pizza, N}.
pasta(N) -> server ! {pasta, N}.
risotto(N) -> server ! {risotto, N}.
zuppa(N) -> server ! {zuppa, N}.
tot() -> server ! {tot}.
stop() -> exit(we).

print_list([], T) -> io:format("Totale ordini: ~p~n", [T]);
print_list([{C, Q}|TL], T) -> io:format("~p: ~p~n", [C,Q]), print_list(TL, T+Q).

loop(Dict) ->
    receive
         {Key, N} -> io:format("~p: ~p~n", [Key, N]), loop(dict:update(Key, fun(X) -> X+N end, N, Dict));
         {tot} -> spawn(fun() -> print_list(dict:to_list(Dict), 0) end), loop(Dict)
     end.