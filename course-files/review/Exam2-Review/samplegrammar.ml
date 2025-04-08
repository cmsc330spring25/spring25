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

let rec lexer input index = (
  if index >= String.length input then [] else (
    if Str.string_match (Str.regexp "(") input index then
      Tok_LParen::(lexer input (index + 1))

    else if Str.string_match (Str.regexp ")") input index then
      Tok_RParen::(lexer input (index + 1))

    else if Str.string_match (Str.regexp "\\+") input index then
      Tok_Plus::(lexer input (index + 1))

    else if Str.string_match (Str.regexp "and") input index then
      Tok_And::(lexer input (index + 3))

    else if Str.string_match (Str.regexp "true") input index then
      Tok_True::(lexer input (index + 4))

    else if Str.string_match (Str.regexp "4\\|5") input index then
      let num = Str.matched_string input in
      Tok_Int(int_of_string num)::(lexer input (index + 1))
    
    else if Str.string_match (Str.regexp " \\|\n\\|\t") input index then
      lexer input (index + 1)

    else failwith "sadge"
  )
)

let rec lexer_main input = lexer input 0


(*
grammar:
E → M and E | M
M → N + M | N
N → 4 | 5 | true | (E)
*)

type ast = Add of ast * ast | And of ast * ast | Int of int | Bool of bool

let rec parse_E input = (
  (*E → M and E | M*)
  (*always starts with M, so let's just get that out of the way. If it did not always start with M, we would skip straight to pattern matching*)
  let (toks_after_m, m_expr) = parse_M input in (*consume M*)
  match toks_after_m with (*either the "and N" case or the wild case --- M and E | M*)
  |Tok_And::toks_after_and -> ( (*M and E case - consume Tok_And*)
    let (toks_after_e, e_expr) = parse_E toks_after_and in (*consume E*)
    (toks_after_e, And(m_expr, e_expr)) (*return result based on common sense*)
  )
  |_ -> (toks_after_m, m_expr) (*M case - nothing to consume*)
)

and parse_M input = (
  (*M → N + M | N*)
  (*always starts with N, so let's just get that out of the way. If it did not always start with N, we would skip straight to pattern matching*)
  let (toks_after_n, n_expr) = parse_N input in (*consume N*)
  match toks_after_n with (*either the "+ M" case or the wild case --- N + M | N*)
  |Tok_Plus::toks_after_plus -> ( (*N + M case - consume Tok_Plus*)
    let (toks_after_m, m_expr) = parse_M toks_after_plus in (*consume M*)
    (toks_after_m, Add(n_expr, m_expr)) (*return result based on common sense*)
  )
  |_ -> (toks_after_n, n_expr) (*N case - nothing to consume*)
)

and parse_N input = (
  (*N → 4 | 5 | true | (E)*)
  (*we don't know what it starts with always, so skip straight to pattern matching*)
  match input with
  |Tok_Int(n)::toks_after_int -> ( (*consume int*)
    (*4 or 5 case*)
    (toks_after_int, Int(n))
  )
  |Tok_True::toks_after_bool -> ( (*consume bool*)
    (*true case*)
    (toks_after_bool, Bool(true))
  )
  |Tok_LParen::toks_after_lparen -> ( (*consume opening parentheses*)
    (*(E) case*)
    let (toks_after_E, e_expr) = parse_E toks_after_lparen in (*consume E*)
    match toks_after_E with (*expect closing parentheses*)
    |Tok_RParen::toks_after_rparen -> (toks_after_rparen, e_expr) (*consume closing parentheses*)
    |_ -> failwith "expected closing parentheses"
  )
  |_ -> (
    (*
    unlike the "N + M" vs. "N" case, where we know there is either a plus sign which we can parse or there is no plus sign
    and so somebody else can parse that leftover stuff if needed, in this case, there is *no possible situation* where N
    does not start with 4, 5, true, or (, and so we can fail directly.
    *)
    failwith "expected 4, 5, true, or ("
    )
)

let parser_main input = (
  match parse_E input with 
  |([], x) -> x
  |(t, x) -> failwith "not EOF :("
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

(*eval takes in an AST and simplifies it to a base case - in this case, an Int or a Bool*)
let rec eval t = (
  match t with
  |Add(e1, e2) -> (
    (*opsem rules says evaluate e1 and e2, then + them*)
    let v1_wrapper = eval e1 in
    let v2_wrapper = eval e2 in 
    match v1_wrapper, v2_wrapper with (*by our metalanguage, we can only + integers together, so we need to make sure we can do that*)
    |Int(v1), Int(v2) -> Int(v1 + v2)
    |_ -> failwith "the metalanguage can't deal with +ing non integers sorry"
  )
  |And(e1, e2) -> (
    (*opsem rules says evaluate e1 and e2, then && them*)
    let v1_wrapper = eval e1 in
    let v2_wrapper = eval e2 in 
    match v1_wrapper, v2_wrapper with (*by our metalanguage, we can only && booleans together, so we need to make sure we can do that*)
    |Bool(v1), Bool(v2) -> Bool(v1 && v2)
    |_ -> failwith "the metalanguage can't deal with &&ing non booleans sorry"
  )
  |Int(n) -> (Int(n)) (*opsem rules say n => n*)
  |Bool(b) -> (Bool(b)) (*opsem rules say b => b*)
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

(*typecheck takes in an AST and simplifies it to a type - in this case, an TypeInt or a TypeBool*)
(*it looks *exactly* like the eval function, but instead of returning ASTs or matching results against ASTs, use types instead*)
let rec typecheck t = (
  match t with
  |Add(e1, e2) -> (
    (*typecheck rules says type e1 and e2, then if they're both ints, e1 + e2 is also an int*)
    let t1 = typecheck e1 in
    let t2 = typecheck e2 in 
    match t1, t2 with (*by our typecheck rules, we can only + integers together, so we need to make sure these two things are TypeInt*)
    |TypeInt, TypeInt -> TypeInt
    |_ -> failwith "the typing rules say + can only act on integers - fail"
  )
  |And(e1, e2) -> (
    (*typecheck rules says type e1 and e2, then if they're both bools, e1 and e2 is also a bool*)
    let t1 = typecheck e1 in
    let t2 = typecheck e2 in 
    match t1, t2 with (*by our typecheck rules, we can only and booleans together, so we need to make sure these two things are TypeBool*)
    |TypeBool, TypeBool -> TypeBool
    |_ -> failwith "the typing rules say and can only act on booleans - fail"
  )
  |Int(n) -> TypeInt (*typecheck rules say n => int*)
  |Bool(b) -> TypeBool (*opsem rules say b => bool*)
)