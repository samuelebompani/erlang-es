-module(es3_ring_distr).
-export([start/3]).

%send M messages with a distributed ring of N processes. es3_ring_central.erl contains the same exercise with a centralized control.
%
start(M, N, Message) -> aux(M,N,Message,self()).

aux(M, 1, Message, First) -> First ! {message, M, self(), Message}, loop(First);
aux(M, N, Message, First) -> loop(spawn(fun() -> aux(M, N-1, Message, First) end)).

loop(F) ->
    receive
        {die, 0} -> die;
        {message, 0, _, _} -> F ! {die, 0}, die; %after M messages, the process sends a message to the next process and kills himself.
        {message, M, From, Message} -> io:format("[~p] Message from ~p: ~p~n", [self(), From, Message]), F ! {message, M-1, self(), Message}, loop(F)
    end.