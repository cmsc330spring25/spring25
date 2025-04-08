## Grammar: 
$$E \rightarrow M+E\mid M-E\mid M$$
$$M \rightarrow N\gt M \mid N\lt M \mid N$$ 
$$N \rightarrow n\mid b\mid (E)$$
$$\text{where }n\in \mathbb{Z}, b\text{ is a boolean} $$

## Types:
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
```

## Code:

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
(26)                  (match t with
(27)                   | Tok_RParen::t -> t,tree
(28)                   | _ -> raise (Failure("Nope")))
```

## Errors:
- `line 5`: calls `parse_E` when it should call `parse_M` according to grammar
- `line 14`: `toks` is a list of tokens, so these patterns would not suffice. According to how we should be building LL(1) parsers, we should be looking ahead here; replace `toks` with `lookahead toks`
- `lines 22, 23`: `Num(x)` and `Bool(x)` do not match our desired return paradigm of `(rest_toks, ast)`. Should `match_toks` to get the rest of the tokens.
- `line 26`: `t` is the rest of the tokens after a `(`, but we want to match on the tokens after we parsed the `E`
