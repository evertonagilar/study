-module(world).
-export([start/0]).

start() -> 
	Joe	= spawn(person, init, ['Joe']),
	Everton	= spawn(person, init, ['Everton']),
	Rafael	= spawn(person, init, ['Rafael']),
	AuAu	= spawn(dog, init, ['AuAu']),

	Joe ! { self(), "Ola Joe, tudo bem?" }.
	


