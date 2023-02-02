/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * %CopyrightEnd%
 */

grammar lee_lang;

/*
    Lexer rules
*/

fragment Letter
    :   [a-zA-Z]
    ;

fragment Digit
            :   [0-9]
            ;

fragment NonZeroDigit
            :   [1-9]
            ;


// Keywords

ABSTRACT : 'abstract';
ASSERT : 'assert';
BOOLEAN : 'boolean';
BREAK : 'break';
BYTE : 'byte';
CASE : 'case';
CATCH : 'catch';
CHAR : 'char';
CLASS : 'class';
CONST : 'const';
CONTINUE : 'continue';
DEFAULT : 'default';
DO : 'do';
DOUBLE : 'double';
ELSE : 'else';
ENUM : 'enum';
EXPORTS : 'exports';
EXTENDS : 'extends';
FINAL : 'final';
FINALLY : 'finally';
FLOAT : 'float';
FOR : 'for';
IF : 'if';
GOTO : 'goto';
IMPLEMENTS : 'implements';
IMPORT : 'import';
INSTANCEOF : 'instanceof';
INT : 'int';
INTERFACE : 'interface';
LONG : 'long';
MODULE : 'module';
NATIVE : 'native';
NEW : 'new';
PACKAGE : 'package';
PRIVATE : 'private';
PROTECTED : 'protected';
PROVIDES : 'provides';
PUBLIC : 'public';
RETURN : 'return';
SHORT : 'short';
STATIC : 'static';
SUPER : 'super';
SWITCH : 'switch';
SYNCHRONIZED : 'synchronized';
THIS : 'this';
THROW : 'throw';
THROWS : 'throws';
TO : 'to';
TRY : 'try';
VOID : 'void';
WHILE : 'while';
WITH : 'with';
UNDER_SCORE : '_';

// Identifiers

Identifier
    :   Letter (Letter | Digit)*
    ;

//
// Whitespace and comments
//

//NL : ( '\r'? '\n' | '\r') + -> skip;

WS:                 [ \t\r\n\u000C]+ -> skip;

//WS  :  [ \t\r\n]+ -> skip
//    ;

//COMMENT
//    :   '/*' .*? '*/' -> skip
//    ;
//
//LINE_COMMENT
//    :   '//' ~[\r\n]* -> skip
//    ;


// Null Literal

NullLiteral
	:	'null'
	;


// Separators

LPAREN : '(';
RPAREN : ')';
LBRACE : '{';
RBRACE : '}';
LBRACK : '[';
RBRACK : ']';
SEMI : ';';
COMMA : ',';
DOT : '.';


// Operators
ASSIGN:             '=';
GT:                 '>';
LT:                 '<';
BANG:               '!';
TILDE:              '~';
QUESTION:           '?';
COLON:              ':';
EQUAL:              '==';
LE:                 '<=';
GE:                 '>=';
NOTEQUAL:           '!=';
AND:                '&&';
OR:                 '||';
INC:                '++';
DEC:                '--';
ADD:                '+';
SUB:                '-';
MUL:                '*';
DIV:                '/';
MOD:                '%';


/*
    Parse rules
*/

module
    : moduleId moduleBody
    ;

moduleId
    : MODULE qualifiedName ';'
    ;

moduleBody
    : ( importDecl | classDecl | interfaceDecl )*
    ;

importDecl
    : IMPORT qualifiedName ';'
    ;

qualifiedName
    :   Identifier ( '.' Identifier)*
    ;

classDecl
    : visibilityDecl CLASS Identifier '{' '}'
    ;

interfaceDecl
    : visibilityDecl INTERFACE Identifier '{' '}'
    ;

visibilityDecl
    : ( PUBLIC | PRIVATE )?
    ;


