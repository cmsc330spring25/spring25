E -> M + E | M - E | M
M -> N > M | N < M | N
N -> n in Z | b in {true, false} | (E)

```ocaml
type token = 
  Tok_Plus 
  | Tok_Minus 
  | Tok_LT 
  | Tok_GT 
  | Tok_LParen 
  | Tok_RParen 
  | Int of int 
  | Boolean of bool
  
type ast = 
  Add of ast * ast 
  | Sub of ast * ast 
  | LT of ast * ast 
  | GT of ast * ast 
  | Num of int 
  | Bool of bool

let match_token toks tok = 
  match toks with
  [] -> raise (Failure("Error"))
  |h::t when h = tok -> t
  |h::_ -> raise (Failure("Error"))

let lookahead toks = 
  match toks with
  h::t -> h
  |_ -> raise (Failure("Error"))
```




<!-- LL(1) parser -->
```ocaml
(1) let rec parse toks =
(2)    let (toks, tree) = parse_E toks in
(3)    if toks = [] then tree else raise (Failure("Nope"))

(4) and parse_E toks = 
(5)   let (toks,tree1) = parse_E toks in 
(6)   match lookahead toks with
(7)   | Tok_Plus -> let t = match_token toks Tok_Plus in
(8)                 let (toks,tree2) = parse_E t in (toks,Add(tree1,tree2))
(9)   | Tok_Minus -> let t = match_token toks Tok_Minus in
(10)                 let (toks,tree2) = parse_E t in (toks,Sub(tree1,tree2))
(11)  | _ -> (toks,tree1)

(12) and parse_M toks = 
(13)  let (toks,tree1) = parse_P toks in 
(14)  match toks with
(15)  | Tok_LT -> let t = match_token toks Tok_LT in
(16)              let (toks,tree2) = parse_M t in (toks,LT(tree1,tree2))
(17)  | Tok_GT -> let t = match_token toks Tok_GT in
(18)              let (toks,tree2) = parse_M t in (toks,GT(tree1,tree2))
(19)  | _ -> (toks,tree1)

(20) and parse_P toks = 
(21)  match lookahead toks with
(22)  | Int(x) -> Num(x)
(23)  | Boolean(x) -> Bool(x)
(24)  | Tok_LParen -> let t = match_token toks Tok_LParen in
(25)                  let (toks,tree) = parse_E t in 
(26)                  begin match t with
(27)                   | Tok_RParen::t -> t,tree
(28)                   | _ -> raise (Failure("Nope"))
(29)                  end
```
