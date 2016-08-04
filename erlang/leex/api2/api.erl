-module(api).

-export([parse/1]).

parse(S) ->
	{ok, T, _} = api_scan:string(S),
	api_parse:parse(T).
