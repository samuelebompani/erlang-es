-module(es3_ring_central).
-export([start/3]).

%send M messages with a centralized ring of N processes. es3_ring_distr.erl contains the same exercise without a centralized control.
%The main process creates the ring, with the function create/3, then sends the message to the first process of the ring.
start(M, N, Message) -> Pid = self(), First = spawn(fun() -> create(N, self(), Pid) end),
    receive
        {ok, ready} -> First ! {message, Pid, M, Message}
    end.

create(N, _, _) when N<1 -> done;
create(1, Father, CentralP) -> CentralP ! {ok, ready}, loop(Father); %CentralP is the main process.
create(N, Father, CentralP) -> create(N-1, spawn(fun() -> loop(Father) end), CentralP).

loop(F) ->
    receive
        {die, 0} -> die;
        {message, _, 0, _} -> F ! {die, 0}, die; %after M messages, the process sends a message to the next process and kills himself.
        {message, From, N, Message} -> io:format("[~p] Message from ~p: ~p~n", [self(), From, Message]), F ! {message, self(), N-1, Message}, loop(F)
    end.