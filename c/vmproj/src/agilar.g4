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

fragment LOWERCASE_CHARS    : [a-zá-ú] ;
fragment UPPERCASE_CHARS    : [A-ZÁ-Ú] ;
fragment DIGIT              : [0-9] ;
fragment DIGIT_GT_0         : [1-9] ;

WHITESPACE          : (' ' | '\t') -> skip;

IDENTIFIER: ( DIGIT_GT_0 | UPPERCASE_CHARS | LOWERCASE_CHARS ) ( DIGIT | UPPERCASE_CHARS | LOWERCASE_CHARS )+;

END : ';' ;

/*
    Parse rules
*/

program : programSmnt ;

programSmnt: 'program' IDENTIFIER END? ;

