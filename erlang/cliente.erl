-module(cliente).
-compile(export_all).

nano_client_eval(Str) ->
	{ok, Socket} =	gen_tcp:connect("localhost", 2345, [binary, {packet, 4}]),
	ok = gen_tcp:send(Socket, term_to_binary(Str)),
	receive
		{tcp,Socket,Bin} ->
			io:format("Client received binary = ~p~n",[Bin]),
			Val = binary_to_term(Bin),
			io:format("Client result = ~p~n",[Val]),
			gen_tcp:close(Socket)
	end.
