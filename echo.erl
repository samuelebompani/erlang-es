-module(echo).
-export([start/0, stop/0, print/1]).

%Write a server that will wait in a receive loop until a message is sent to it. Depending on the message, 
%it should either print its contents and loop again, or terminate. You want to hide the fact that you are dealing with a process, 
%and access its services through a functional interface, which you can call from the shell.

%This functional interface, exported in the echo.erl module, will spawn the process and send messages to it. The function interfaces are shown here:

%    echo:start() ⇒ ok
%    echo:print(Term) ⇒ ok
%    echo:stop() ⇒ ok

start() -> register(server, spawn(fun() -> loop() end)).

stop() -> server ! {stop, 0}.

print(Message) -> server ! {print, Message}.

loop() ->
    receive
        {print, Message} -> io:format("~p~n", [Message]), loop();
        {stop, _} -> io:format("Shutting down... ~n"), exit(not_normal)
    end.