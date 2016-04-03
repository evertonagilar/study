-module(tarde1).
-compile(export_all).


my_ponto() -> {ponto, 10, 20}.

-record(user, {id, nome, group, age}).


admin_panel(#user{nome=Nome, group="admin"}) -> 
	Nome ++ " eh permitido.";
	
admin_panel(#user{nome=Nome}) ->
	Nome ++ " não eh permitido.".
	
	
adult_session(U = #user{}) when U#user.age > 17 -> true;

adult_session(_) -> false.	
	
	
% criando um processo com lambda
quanto_eh_2plus2() -> spawn(fun() -> io:format("value: ~p~n", [2+2]) end).
	

% spawn 10 processos
spawn_10_processos() -> [spawn(fun() -> 
								timer:sleep(10), 
								io:format("~p~n", [X]) end) || X <- lists:seq(1, 10)].





