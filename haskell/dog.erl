-module(dog).
-export([init/1]).

init(Name) -> 
	io:write(Name).


