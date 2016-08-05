Definitions.

D = [0-9]
W = [\s]
DoubleQuoted = "(\\\^.|\\.|[^\"])*"
SingleQuoted = '(\\\^.|\\.|[^\'])*'
L =	[a-z]
U = [A-Z]



Rules.

%% Numbers

{D}+\.{D}+ : {token, {float, TokenLine, list_to_float(TokenChars)}}.

{D}+ :	{token, {integer, TokenLine, list_to_integer(TokenChars)}}.
	
%% Ignore whitespaces

{W}+ : skip_token.

%% Strings

{DoubleQuoted} : {token, {string, TokenLine, lists:sublist(TokenChars, 2, TokenLen - 2)}}.
	
{SingleQuoted} : {token, {string, TokenLine, lists:sublist(TokenChars, 2, TokenLen - 2)}}.

%% Variable

({U}|{L}|_)({U}|{L}|_|{D})*	: {token, {var, TokenLine, TokenChars}}.


%% Operators

\+ :	{token, {add_op, TokenLine, list_to_atom(TokenChars)}}.
\- :	{token, {add_op, TokenLine, list_to_atom(TokenChars)}}.
\* :	{token, {mult_op, TokenLine, list_to_atom(TokenChars)}}.
\/ :	{token, {mult_op, TokenLine, list_to_atom(TokenChars)}}.


= :		{token, {assigment_op, TokenLine, list_to_atom(TokenChars)}}.


== :		{token, {bool_op, TokenLine, list_to_atom(TokenChars)}}.
(!=|\<\>) :	{token, {bool_op, TokenLine, list_to_atom(TokenChars)}}.
>  :		{token, {bool_op, TokenLine, list_to_atom(TokenChars)}}.
>= :		{token, {bool_op, TokenLine, list_to_atom(TokenChars)}}.
<  :		{token, {bool_op, TokenLine, list_to_atom(TokenChars)}}.
<= :		{token, {bool_op, TokenLine, list_to_atom(TokenChars)}}.


\&\& :		{token, {set_op, TokenLine, list_to_atom(TokenChars)}}.
\|\| :		{token, {set_op, TokenLine, list_to_atom(TokenChars)}}.


Erlang code.

