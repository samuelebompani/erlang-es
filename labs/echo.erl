-module(echo).
-export([start/0, stop/0, print/1]).

%Write a server that will wait in a receive loop until a message is sent to it. Depending on the message, 
%it should either print its contents and loop again, or terminate. You want to hide the fact that you are dealing with a process, 
%and access its services through a functional interface, which you can call from the shell.

%This functional interface, exported in the echo.erl module, will spawn the process and send messages to it. The function interfaces are shown here:

%    echo:start() ⇒ ok
%    echo:print(Term) ⇒ ok
%    echo:stop() ⇒ ok

%Then write a client to be connected to such a server and link these two processes each other. 
%When the stop function is called, instead of sending the stop message, make the first process terminate abnormally.
%This should result in the EXIT signal propagating to the other process, causing it to terminate as well.

start() -> Pid = spawn(fun() -> loop() end),
    register(server, Pid),
    link(Pid).

stop() -> exit(stop_called).

print(Message) -> server ! {print, Message}.

loop() ->
    receive
        {print, Message} -> io:format("~p~n", [Message]), loop()
    end.