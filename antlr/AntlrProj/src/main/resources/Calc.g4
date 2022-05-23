grammar Calc;

/* lexer rules */

fragment LETTER : [A-Za-z];
fragment DIGIT : [0-9];

ADD_OP      : '+' ;
SUB_OP      : '-' ;
MUL_OP      : '*' ;
DIV_OP      : '/' ;
POW_OP      : '^' ;
ASSIGN_OP   : '=' ;

LPARENT     : '(' ;
RPARENT     : ')' ;

BEGIN_BLOCK : '{' ;
END_BLOCK   : '}' ;

STATEMENT_RET   : ';' ;

RETURN      : 'return';

ID  : ( LETTER | '_' ) (LETTER | DIGIT | '_')* ;

INT         : DIGIT+ ;
DOUBLE      : DIGIT+ ('.' DIGIT+)? ;
NUMBER      : ( INT | DOUBLE ) ;

END : EOF -> skip ;

NEWLINE : ('\r'? '\n' | '\r')+ -> skip;
WS  : (' ' | '\r' ) -> skip;



/* parse rules */

main    : (functionDecl | statementBlock)+ ;

statementBlock  :  BEGIN_BLOCK
                       ( statementBlock STATEMENT_RET? )*
                   END_BLOCK
                   | ( statement STATEMENT_RET )
                ;

statement   : return
            | expression
            | assigment
            | functionCall
            ;


expression      : fator
                | LPARENT inner=expression RPARENT
                | left=expression  operator=POW_OP  right=expression
                | left=expression  operator=(MUL_OP | DIV_OP)  right=expression
                | left=expression  operator=(ADD_OP | SUB_OP)  right=expression
                ;

assigment       : ID ASSIGN_OP expression ;

functionCall    : ID LPARENT functionArgs RPARENT ;

functionArgs   : fator? (',' fator)* ;

functionDecl    : ID LPARENT functionParams RPARENT statementBlock ;

functionParams  : ID? (',' ID)* ;

return          : RETURN expression ;

fator           : identifier
                | number
                ;

number          :  (ADD_OP | SUB_OP)? INT        # Int
                |  (ADD_OP | SUB_OP)? DOUBLE     # Double
                ;

identifier      : functionCall
                | variableDecl
                ;

variableDecl        :   ID;

