Definitions.


D = [0-9]
WS = [\s,;]
V = [a-zA-Z_][a-zA-Z0-9_]+
OP = (>|>=|=|<|<=)
S = (".*"|'.*')
BOOL = (true|false)
OPEN_P = \(
CLOSE_P = \)

Rules.


{D}+ :
  {token,{integer,TokenLine,list_to_integer(TokenChars)}}.

{D}+\.{D}+((E|e)(\+|\-)?{D}+)? :
  {token,{float,TokenLine,list_to_float(TokenChars)}}.

{BOOL} :
  {token,{bool,TokenLine,list_to_atom(TokenChars)}}.

and :
  {token,{intersection,TokenLine,list_to_atom(TokenChars)}}.

or :
  {token,{union,TokenLine,list_to_atom(TokenChars)}}.

in :
  {token,{set,TokenLine,list_to_atom(TokenChars)}}.

null :
  {token,{null,TokenLine,list_to_atom(TokenChars)}}.

{V} :
  {token,{var,TokenLine,TokenChars}}.

{S} :
  Str = strip(TokenChars, TokenLen),
  {token,{string,TokenLine, Str}}.

(asc|desc) :
  {token,{sort_option,TokenLine,list_to_atom(TokenChars)}}.

{OP} :
  {token,{operator,TokenLine,list_to_atom(TokenChars)}}.

{OPEN_P} :
  {token,{open_p,TokenLine,list_to_atom(TokenChars)}}.

{CLOSE_P} :
  {token,{close_p,TokenLine,list_to_atom(TokenChars)}}.

{WS}+ :
  skip_token.


Erlang code.

strip(Str, TokenLen) -> string:sub_string(Str, 2, TokenLen-1).


