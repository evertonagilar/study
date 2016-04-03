-module(aula4).
-compile(export_all).

royal(P) -> if P > 9000 -> true; true -> false	end.	

peasant(P) -> not (royal(P)).

% operador Construct (:)
% [2|[4,5]].


