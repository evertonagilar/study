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

grammar agilar;

/*
    Lexer rules
*/

fragment LOWERCASE_LETTER    : [a-zá-ú] ;
fragment UPPERCASE_LETTER    : [A-ZÁ-Ú] ;
fragment LETTER              : ( LOWERCASE_LETTER | UPPERCASE_LETTER ) ;
fragment DIGIT              : [0-9] ;
fragment DIGIT_GT_0         : [1-9] ;
fragment SIGN               : [ + | - ] ;

WHITESPACE : (' ' | '\t') -> skip;

VOID : 'void' ;

INT : 'int' ;

OPEN_P : '(' ;

CLOSE_P : ')' ;

IDENTIFIER : LETTER | ( DIGIT | LETTER )*;

NL : ( '\r'? '\n' | '\r') ? -> skip;

END : ';' ;

/*
    Parse rules
*/

program: program_id program_body  ;

program_id : 'program' IDENTIFIER END? ;

program_body : interface_decl implementation_decl ;

interface_decl : 'interface' func_list_decl*;

implementation_decl : 'implementation' ;

func_list_decl : func_type_decl IDENTIFIER OPEN_P CLOSE_P END?;

func_type_decl : VOID | INT ;

