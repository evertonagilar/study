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

fragment LOWERCASE_LETTER    : [a-zá-ú] ;
fragment UPPERCASE_LETTER    : [A-ZÁ-Ú] ;
fragment LETTER              : ( LOWERCASE_LETTER | UPPERCASE_LETTER ) ;
fragment DIGIT              : [0-9] ;
fragment DIGIT_GT_0         : [1-9] ;
fragment SIGN               : [ + | - ] ;

WHITESPACE : (' ' | '\t') -> skip;

VOID : 'void' ;

INT : 'int' ;

CHAR : 'char' ;

OPEN_P : '(' ;

CLOSE_P : ')' ;

OPEN_K : '{' ;

CLOSE_K : '}' ;

PUBLIC : 'public';

PRIVATE : 'private';

CLASS : 'class';

IMPORT : 'import';

MODULE : 'module';

INTERFACE : 'interface';

IDENTIFIER : LETTER ( DIGIT | LETTER | '_' )*;

NL : ( '\r'? '\n' | '\r') ? -> skip;

END : ';' ;

/*
    Parse rules
*/

module: module_id module_body  ;

module_id : MODULE IDENTIFIER END? ;

module_body : ( import_decl | class_decl | interface_decl )* ;

import_decl : IMPORT IDENTIFIER END? ;

class_decl : visibility_decl CLASS IDENTIFIER OPEN_K CLOSE_K END? ;

interface_decl : visibility_decl INTERFACE IDENTIFIER OPEN_K CLOSE_K END? ;

visibility_decl : ( PUBLIC | PRIVATE )? ;

func_list_decl : func_type_decl IDENTIFIER OPEN_P CLOSE_P END? ;

func_type_decl : VOID | INT | CHAR ;

