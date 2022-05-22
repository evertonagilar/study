grammar BibliotecaTextSearch;

/*
   DSL para validar a pesquisa geral do portal biblioteca
   @author: Everton de Vargas Agilar
*/

/*
 * Lexer Rules
 */

fragment LOWERCASE  : [a-zá-ú] ;
fragment UPPERCASE  : [A-ZÁ-Ú] ;
fragment DIGIT     : [0-9] ;

ASPA_SIMPLES        : '\'' -> skip;

WHITESPACE          : (' ' | '\t') -> skip;

LPAREN              : '(';

RPAREN              : ')';

OR                   : ('OR' | '||');

AND                  : ('AND' | '&&');

NOT                  : ('NOT' | '-');

STRING              : '"' (~('"' | '\\' | '\r' | '\n') | '\\' ('"' | '\\'))* '"' ;

TEXT                :  (UPPERCASE | LOWERCASE | DIGIT | '*' | '#' | '$' | '?' | '.' | '-' | ',' | SPECIAL_CHAR )+ ;

SPECIAL_CHAR        : ('[' | ']' | '{' | '}' | '=' | ':' | '!' | '@' | '%' | '^' | '~') ;

NEWLINE             : ('\r'? '\n' | '\r')+ ;

END                 : EOF -> skip;



/*
 * Parser Rules
 */

pesquisa            :  expressao+ ;

expressao           : lparen expressao rparen ((or_oper | and_oper | not_oper) expressao )?
                    | termo
                    ;

termo               : fator+                                    # MultFat
                    | termo or_oper expressao                   # TermOrExpr
                    | termo and_oper expressao                  # TermAndExpr
                    | termo not_oper expressao                  # TermNotExpr
                    ;

lparen              : LPAREN ;

rparen              : RPAREN ;

or_oper             : OR ;

and_oper            : AND ;

not_oper            : NOT ;

fator               : TEXT                  # Text
                    | STRING                # String
                    ;


