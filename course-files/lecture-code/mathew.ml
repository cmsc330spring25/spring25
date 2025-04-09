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
    |N ^ T
    |N
N -> n | (E) | let var = E in E
n is any integer
*)

(* -------------------------------------------------------------------------- *)

type token = Int of string | Star | Slash | Dash | Plus| LParen | RParen | Carot
             |Let | Equal | In |Var of string

let lexer program = 
  let mkcompile s = Re.compile (Re.Perl.re s) in
  let add_re = mkcompile "^\\+" in
  let sub_re = mkcompile "^-" in
  let mult_re = mkcompile "^\\*" in
  let div_re = mkcompile "^\\/" in
  let lp_re = mkcompile "^\\(" in
  let rp_re = mkcompile "^\\)" in
  let c_re = mkcompile "^\\^" in
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
    if Re.execp c_re program then
      Carot::(lexer (String.sub program 1 ((String.length program) - 1)))
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
                           | Exp of ast * ast
                           | Let of string * ast * ast
(* Note: 'and' keyword allows for mutually defined functions. Typically if you 
         call a function without defining it first, ocaml will yell at you.
         The 'and' keyword allows you to define within the same "scope". 
         For example:

let is_even x = if x = 0 then true else is_odd (x-1)
and
let is_odd x = if x = 0 then false else is_even (x-1)

(if e1:bool then e2:t else e3:t):t
if if true then false else true then 5 else if true then 6 else 7

E -> + T E 
    |- T E
    |T
T -> N * T 
    |N / T
    |N
N -> n | (E)
n is any integer

+ 1 + 2 3

     E
/ |     \
+ T     E
  |   / | \
  N   + T E
  |     | 

  1     N T
        | |
        2 N
          |
          3

+ (+ 1 2) + 3 4
+ ( [+ 1 2] ) [+ 3 4]


E -> + T E 
    |- T E
    |T
T -> N * T 
    |N / T
    |N
N -> n 
    |(E)
n is any integer
*)
let parser tokens = 
  let rec parse_e tokens = 
    match tokens with
       Plus::toks -> let ttree,tremain = parse_t toks in
                     let etree,eremain = parse_e tremain in
                     Add(ttree,etree),eremain
      |Dash::toks -> let ttree,tremain = parse_t toks in
                  let etree,eremain = parse_e tremain in
                  Sub(ttree,etree),eremain
      |_ -> parse_t tokens
  and parse_t tokens = 
    let ntree,nremain = parse_n tokens in
      match nremain with
         Star::toks -> let ttree,tremain = parse_t toks in
                    Mult(ntree,ttree),tremain
        |Slash::toks -> let ttree,tremain = parse_t toks in
                     Div(ntree,ttree),tremain
        |Carot::toks -> let ttree,tremain = parse_t toks in
                     Exp(ntree,ttree),tremain
        |_ -> ntree,nremain
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

(*
type ast = Value of string | Add of ast * ast | Sub of ast * ast 
                           | Div of ast * ast | Mult of ast * ast

    Add
    / \
   t1 t2
*)
let rec evaluator tree = 
    let rec lookup v env = match env with
      (x,y)::xs -> if x = v then y else lookup v xs
      |[] -> raise ("undefined variable")
    let rec eval env t = match t with
      |Value(s) -> int_of_string s
      |Var(s) -> lookup s env
      |Let(s,e1,e2) -> let v1 = eval env e1 in
                       let v2 = eval ((s,v1)::env) e2 in
                       v2
      (* A;e1 => v1 A;e2 => v2 v3 is v1 + v2
          ----------------------------------
            A; e1 + e2 => v3 *)
      |Add(t1,t2) -> let v1 = eval env t1 in
                     let v2 = eval env t2 in
                     let v3 = v1 + v2 in
                     v3
      |Sub(t1,t2)  -> let left = eval env t1 in
                     let right = eval env t2 in
                     left - right
      |Div(t1,t2)  -> let left = eval env t1 in
                     let right = eval env t2 in
                     left / right
      |Mult(t1,t2) -> let left = eval env t1 in
                     let right = eval env t2 in
                     left * right
      |Exp(t1,t2) -> let base =  eval env t1 in 
                     let power = eval env t2 in 
                     let rec exp b a p = if p = 0 then 1 else
                        if p = 1 then a
                        else exp b (a * b) (p-1)
                     in exp base base power
    in eval [] tree
