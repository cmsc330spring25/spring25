open Str

(*
open utop
type:
#load "str.cma";;
#use "samplegrammar.ml";; 
*)

(*
lexer cares about some amount of common sense and written rules.
parser cares about the CFG
evaluator/typechecker cares about the opsem/typechecking rules
*)

(*
grammar:
E → M and E | M
M → N + M | N
N → 4 | 5 | true | (E)
*)

(*
opsem rules:                                            typing rules:

A; e1 => v1    A; e2 => v2    v3 is v1 && v2                      G- e1 : bool    G- e2 : bool (optional: "and : bool -> bool -> bool" or something similar)
              A; e1 and e2 => v3                                      G- e1 and e2 : bool

A; e1 => v1    A; e2 => v2    v3 is v1 + v2                       G- e1 : int    G- e2 : int (optional: "+ : int -> int -> int" or something similar)
              A; e1 + e2 => v3                                        G- e1 + e2 : int

A; n => n          A; b => b                                      G- n : int         G- b : bool

*)

(*types needed will be provided if there is a coding question on this*)
type token =
| Tok_Int of int
| Tok_True
| Tok_Plus
| Tok_And
| Tok_LParen
| Tok_RParen

(*Lexer speedrun*)

(*

Syntax you need:

String.length input 
  => returns an int = length of the "input" string

String.sub input position length
  => returns the substring of the "input" starting at "position" with length "length"

Str.string_match (Str.regexp "hehe") input index
  => returns a bool = whether the given regex matches the given "input" string starting at "index"

Str.matched_string input
  => returns a string = most recent match

*)

(*
  Steps:
  1) check if index is out of bounds, if so, return []
  2) check if input at index matches some regex, if so, return RelevantToken::(recursive call with updated position)
  3) profit
*)

let rec lexer input index = (

)


(*
grammar:
E → M and E | M
M → N + M | N
N → 4 | 5 | true | (E)
*)

type ast = Add of ast * ast | And of ast * ast | Int of int | Bool of bool

(*
Steps:
1) make 1 parser per nonterminal (it should return a (leftover_tokens, new_ast) tuple)
2) if you know all cases must start with some value (ex: start with M in E → M and E | M), get it out of the way
  - store its tuple result (tokens_after_starter_value, parsed_starter_value)
  - rest of parser should work starting with tokens_after_starter_value
3) if cases start with different values, or you have consumed a value and now looking ahead (ex: 4/5/true/( in N → 4 | 5 | true | (E)), match)
  create a match case for each one (plus a wildcard).
  - Ex: "M and E | M" after having consumed M becomes and "and E", so make 1 match case for "and" - and a match case for wildcard
    - in this case, wildcard should not fail, since one case *could have been already fully consumed*, so just return the tuple
  - Ex: "4 | 5 | true | (E)", so make 4 match cases for "4", "5", "true", "(" (can combine 4 and 5 if you want) - and a match case for wildcard
    - in this case, wildcard should fail, since no possibility exists that we already consumed a whole case, so fail
4) nest these as needed, consuming a terminal/nonterminal then continuing on the case
5) profit
*)

let rec parse_E input = (
  (*E → M and E | M*)
)

and parse_M input = (
  (*M → N + M | N*)
)

and parse_N input = (
  (*N → 4 | 5 | true | (E)*)
)

let parser_main input = (
  (*possibly fail if toplevel parser helper did not return empty token list*)
)



(*
opsem rules:

A; e1 => v1    A; e2 => v2    v3 is v1 && v2
              A; e1 and e2 => v3

A; e1 => v1    A; e2 => v2    v3 is v1 + v2
              A; e1 + e2 => v3

A; n => n          A; b => b
*)

(*
recall the type of the AST:
Add of ast * ast | And of ast * ast | Int of int | Bool of bool
For both opsem and typing, you basically just want 1 match case for each one, then ur all set.
*)

(*
Steps:
1) match t with each of the possible AST types
2) follow the opsem rule for what to do in each type
  - Ex: The rule for "e1 and e2" says "evaluate e1 to v1, evaluate e2 to v2, return v3 which is v1 && v2", so if you cannot do v1 && v2, fail, else return Int(v1 && v2)
  - Ex: The rule for "n" says "n is n" (where it is implied n is a number), so if you see an Int() ast, retun an Int() ast
*)
let rec eval t = (

)


(*
typing rules:

G- e1 : bool    G- e2 : bool (optional: "and : bool -> bool -> bool" or something similar)
              G- e1 and e2 : bool

G- e1 : int    G- e2 : int (optional: "+ : int -> int -> int" or something similar)
              G- e1 + e2 : int

G- n : int         G- b : bool

*)


type typ = TypeInt | TypeBool

(*it looks *exactly* like the eval function, but instead of returning ASTs or matching results against ASTs, use types instead*)
(*
Steps:
1) match t with each of the possible AST types
2) follow the typecheck rule for what to do in each type
  - Ex: The rule for "e1 + e2" says "type e1 to int, type e2 to int, return int", so if any of these types are wrong, fail, else return TypeInt
  - Ex: The rule for "n" says "n is int" (where it is implied n is a number), so if you see an Int() ast, retun a TypeInt typ
*)
let rec typecheck t = (

)