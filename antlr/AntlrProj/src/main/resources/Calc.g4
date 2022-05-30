grammar Calc;

/* lexer rules */

fragment LETTER : [A-Za-z];
fragment DIGIT : [0-9];

IF          : 'if' ;
ELSE        : 'else' ;

ADD_OP      : '+' ;
SUB_OP      : '-' ;
MUL_OP      : '*' ;
DIV_OP      : '/' ;
POW_OP      : '^' ;
EQUAL_OP    : '==' ;
ASSIGN_OP   : '=' ;
LT_OP       : '<' ;
LTE_OP      : '<=' ;
GT_OP       : '>' ;
GTE_OP      : '>=' ;

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

program    : (functionDecl | scriptBlock)+ ;

scriptBlock   : statementBlock
                |  statement+
                ;

statementBlock  :  BEGIN_BLOCK
                       statement*
                   END_BLOCK
                ;

statement   : return
            | expression    statementRet
            | assigment
            | ifDecl
            | statementBlock
            | statementRet
            ;

statementRet    :   STATEMENT_RET ;

expression      : fator
                | LPARENT inner=expression RPARENT
                | left=expression  operator=POW_OP  right=expression
                | left=expression  operator=(MUL_OP | DIV_OP)  right=expression
                | left=expression  operator=(ADD_OP | SUB_OP)  right=expression
                | left=expression  operator=(LT_OP | LTE_OP | GT_OP | GTE_OP | EQUAL_OP)  right=expression
                ;



assigment       : ID ASSIGN_OP expression statementRet ;

functionCall    : ID LPARENT functionArgs RPARENT ;

functionArgs   : fator? (',' fator)* ;

functionDecl    : ID LPARENT functionParams RPARENT statementBlock ;

functionParams  : ID? (',' ID)* ;

ifDecl          : IF LPARENT expression RPARENT trueStat=statementBlock (ELSE falseStat=statementBlock)? ;

return          : RETURN expression statementRet ;

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

