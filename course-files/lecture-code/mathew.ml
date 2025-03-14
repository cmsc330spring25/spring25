#require "re"
(* open utop and run the following
 #use "mathew.ml";;
 (you need the # symbol too)
*)

(* Math-ew
E -> + T E 
    |- T E
    |T
T -> N * T 
    |N / T
    |N
N -> n | (E)
n is any integer
*)

(* -------------------------------------------------------------------------- *)

type token = Int of string | Star | Slash | Dash | Plus| LParen | RParen

let lexer program = 
  let mkcompile s = Re.compile (Re.Perl.re s) in
  let add_re = mkcompile "^\\+" in
  let sub_re = mkcompile "^-" in
  let mult_re = mkcompile "^\\*" in
  let div_re = mkcompile "^\\/" in
  let lp_re = mkcompile "^\\(" in
  let rp_re = mkcompile "^\\)" in
  let num_re = mkcompile "^-?[0-9]+" in
  let ws_re = mkcompile "^ " in
  let rec lexer program = 
    if program = "" then [] 
    else
    if Re.execp add_re program then
      Plus::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp add_re program then
      Plus::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp div_re program then
      Slash::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp mult_re program then
      Star::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp lp_re program then
      LParen::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp rp_re program then
      RParen::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp ws_re program then
      (lexer (String.sub program 1 ((String.length program) - 1)))
    else
    if Re.execp num_re program then
      let num = Re.Group.get (Re.exec num_re program) 0 in
      let num_len = String.length num in
       Int(num)::(lexer (String.sub program num_len 
                                  ((String.length program) - (num_len))))
    else
    if Re.execp sub_re program then
      Dash::(lexer (String.sub program 1 ((String.length program) - 1)))
    else
      let _ = print_string program in
      failwith "not valid word"
  in lexer program

(* -------------------------------------------------------------------------- *)

type ast = Value of string | Add of ast * ast | Sub of ast * ast 
                           | Div of ast * ast | Mult of ast * ast
(* Note: 'and' keyword allows for mutually defined functions. Typically if you 
         call a function without defining it first, ocaml will yell at you.
         The 'and' keyword allows you to define within the same "scope". 
         For example:

let is_even x = if x = 0 then true else is_odd (x-1)
and
let is_odd x = if x = 0 then false else is_even (x-1)
*)
let parser tokens = 
  let rec parse_e tokens = 
    match tokens with
       Plus::toks -> let ntree,nremain = parse_t toks in
                  let etree,eremain = parse_e nremain in
                  Add(ntree,etree),eremain
      |Dash::toks -> let ntree,nremain = parse_t toks in
                  let etree,eremain = parse_e nremain in
                  Sub(ntree,etree),eremain
      |_ -> parse_t tokens
  and parse_t tokens = 
    let ntree,nremain = parse_n tokens in
      match nremain with
         Star::toks -> let ttree,tremain = parse_t toks in
                    Mult(ntree,ttree),tremain
        |Slash::toks -> let ttree,tremain = parse_t toks in
                     Div(ntree,ttree),tremain
        |_ -> parse_n tokens
  and parse_n tokens = match tokens with
     Int(num)::toks -> Value(num),toks
    |LParen::toks -> let etree,eremain = parse_e toks in
                     (match eremain with
                        RParen::toks' -> etree,toks'
                       |_ -> failwith "unbalanced parens")
    |_ -> failwith "error: not gramattically correct"
  in
  let etree,eremain = parse_e tokens in
  match eremain with
  [] -> etree
  |_ -> failwith "left over tokens, invalid grammar"

(* -------------------------------------------------------------------------- *)

let rec evaluate tree = match tree with
   Value(x) -> int_of_string x
  |Add(arg1,arg2) -> (evaluate arg1) + (evaluate arg2)
  |Sub(arg1,arg2) -> (evaluate arg1) - (evaluate arg2)
  |Mult(arg1,arg2) -> (evaluate arg1) * (evaluate arg2)
  |Div(arg1,arg2) -> (evaluate arg1) / (evaluate arg2)

(* -------------------------------------------------------------------------- *)
(*
evaluate (parser (lexer ("+ 1 3 * 7"))) = 22;;
evaluate (parser (lexer ("(+ 1 3) * 7"))) = 28;;
*)
