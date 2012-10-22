
-module(earl_pingpong).
-export([start/0, ping/2, pong/0]).

start() ->
	spawn(?MODULE, pong, []).

pong() ->
	receive
		{ping, Node} ->
			io:format("Ping received !~n"),
	   		Node ! {pong, self()},
			pong();
		{bye} ->
			io:format("Pong quitting~n")
	end.	

ping(0, _Target) -> ok;

ping(N, Target) ->
	%io:format("Pinging !~n"),
	Target ! {ping, self()},
	receive
		{pong, Node} ->
			io:format("Pong received !~n"),
			ping(N-1, Node)
	end.
