homem( joao ).  mulher( maria ). amigo( joao, jose ).
homem( jose ).  mulher( marta ). amigo( joao, pedro ).  
homem( pedro ). mulher( ana ).   amigo( jose, pedro ).
homem( tiago ). mulher( clara ). amigo( pedro, tiago ). 
homem( jonas ). mulher( katia ). amigo( tiago, jonas ). 
homem( paulo ). mulher( vera ).  amigo( katia, vera ).  

chefe( marta, katia ).
chefe( ana, paulo ).
chefe( joao, jose ).
chefe( marta, tiago ).
chefe( ana, pedro ).
chefe( maria, clara ).
chefe( joao, jonas ).
chefe( joao, vera ).

chefia( contabilidade, joao ). primeiro_andar( cadastro ).
chefia( cadastro, marta ).     primeiro_andar( atendimento ).
chefia( producao, ana ).       segundo_andar( contabilidade ).
chefia( atendimento, maria ).  segundo_andar( producao ).

trabalha_em( X, Y ) :- chefia( Y, X ).
trabalha_em( X, Y ) :- chefe( Z, X ), chefia( Y, Z ).

amigo_comum( X, Y ) :- amigo( X, Z ), amigo( Y, Z ).