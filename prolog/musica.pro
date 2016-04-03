pessoa( maria ). 
pessoa( joao ). 
pessoa( armando ). 
pessoa( rolando ). 

instrumento( viol�o ).
instrumento( banjo ). 
instrumento( piano ). 
instrumento( flauta ). 

toca( joao, banjo ). 
toca( joao, viol�o ). 
toca( maria, piano ).
toca( armando, banjo ).
toca( maria, flauta ).
toca( alex, banjo).

cordas( viol�o ).
cordas( banjo ).
cordas( piano ).

madeira( flauta ).

pessoaInstrumentoCorda(P,I) :- pessoa(P), toca(P, I), instrumento(I), cordas(I).
