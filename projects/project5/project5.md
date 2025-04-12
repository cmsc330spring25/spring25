# Project 5: SmallC Optimizer and Type Checker

> [!NOTE]
> **Due**: Thursday April 17, 2025
> **Points**: 35 public, 35 semipublic, 30 secret 

> [!NOTE]
> We have moved towards a new testing framework. You can test it out by running the following. This is required to run public tests.
> 
> ```sh
> opam update
> opam install alcotest 
> ```

## Introduction

In project 4, you implemented SmallC — a **explicitly typed** version of C with a subset of its features. In this project, you will use a **modified** SmallC AST and you will implement:

* An **optimizer** for SmallC which simplifies the SmallC AST using constant folding, constant propagation, and loop unrolling
* A **type Inferencer** for SmallC, which determines the type of each variable in the AST. 
* A **type checker** for SmallC, which verifies if a SmallC expression is well-typed before we run the code. If an expression passes the type checker, it will not cause a type error when it runs.

The changes to the SmallC AST are as follows:
- Moved the operations in `expr` into a `Binop` value which uses a `op` type 
- Added a `read()` to the language (see `expr` CFG)
- Updated the `data_type` variant to include a `Unknown_Type` value.
- Added a `Value` value to the `expr`  type
- Updated the `Assign` value from the `stmt` type
- Removed the `Declare` value from the `stmt` type 

You can see the updated variants and CFGS below. We will discuss what each of these changes affect in the relevant section of the project.
Updated `data_type` type:
```ocaml
type data_type =
  | Int_Type
  | Bool_Type
  | Unknown_Type of int
```

Updated `expr` type:
```ocaml
type op =
  | Add
  | Sub
  | Mult
  | Div
  | Pow
  | Greater
  | Less
  | GreaterEqual
  | LessEqual
  | Equal
  | NotEqual
  | Or
  | And

type expr =
  | Int of int
  | Bool of bool
  | ID of var
  | Binop of op * expr * expr
  | Not of expr
  | Value
```
Updated `expr` CFG:
- Expr -> OrExpr
- OrExpr -> AndExpr `||` OrExpr | AndExpr
- AndExpr -> EqualityExpr `&&` AndExpr | EqualityExpr
- EqualityExpr -> RelationalExpr EqualityOperator EqualityExpr | RelationalExpr
  - EqualityOperator -> `==` | `!=`
- RelationalExpr -> AdditiveExpr RelationalOperator RelationalExpr | AdditiveExpr
  - RelationalOperator -> `<` | `>` | `<=` | `>=`
- AdditiveExpr -> MultiplicativeExpr AdditiveOperator AdditiveExpr | MultiplicativeExpr
  - AdditiveOperator -> `+` | `-`
- MultiplicativeExpr -> PowerExpr MultiplicativeOperator MultiplicativeExpr | PowerExpr
  - MultiplicativeOperator -> `*` | `/`
- PowerExpr -> UnaryExpr `^` PowerExpr | UnaryExpr
- UnaryExpr -> `!` UnaryExpr | PrimaryExpr
- PrimaryExpr -> *`Tok_Int`* | *`Tok_Bool`* | *`Tok_ID`* | `read()` | `(` Expr `)`

Updated `stmt` type:
```ocaml
type stmt =
  | NoOp
  | Seq of stmt * stmt
  | Assign of string * data_type * expr
  | If of expr * stmt * stmt
  | For of string * expr * expr * stmt
  | While of expr * stmt
  | Print of expr
```
Updated `stmt` CFG:
- Stmt -> StmtOptions Stmt | ε
  - StmtOptions -> AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt
    - AssignStmt -> ID `=` Expr `;`
    - PrintStmt -> `printf` `(` Expr `)` `;`
    - IfStmt -> `if` `(` Expr `)` `{` Stmt `}` ElseBranch
      - ElseBranch -> `else` `{` Stmt `}` | ε
    - ForStmt -> `for` `(` ID `from` Expr `to` Expr `)` `{` Stmt `}`
    - WhileStmt -> `while` `(` Expr `)` `{` Stmt `}`

## Part (A): AST optimization

#### `optimize : stmt -> stmt`

* **Description:** Takes in an `stmt` AST and returns a optimized `stmt` AST. See below for what this means.
* **Exception:** Throws a `DivByZeroError` if division by zero occurs.
* **Exception:** Throws a `DeclareError` if there is an unbound variable. 
* **Assumptions:**
  - The AST represents a well typed program. No `TypeErrors` or `DeclareErrors`.
```ocaml
optimize (parse_expr "int main(){x = 1 + 2;}") => Assign("x",Int_Type,Int(3))
optimize (parse_expr "int main(){x = 3/0}") => (* DivByZeroError *)
optimize (parse_expr "int main(){x = y + 3;}") => (* DeclareError)
```

### What even is optimization?
To dive into optimization we first need to understand the difference between *compile-time* and *runtime*. 
In compiled languages such as C, the compilation stage will use a lexer to tokenize the input, and a parser to parse those tokens into an AST. This AST is encoded in some sort of executable format.

During *runtime*, the AST will be evaluated using the inputs given to the program.

Suppose I have a program P as follows: `print(1 + 2)`
When I compile this program, I will end up with an AST such as `Print( Binop( Add, Int 1, Int 2 ) )`
Then, **every time** I run this program, the evaluator will need to add 1 and 2, and then print the result.

&nbsp;

> Well that seems kinda silly, the result of the addition will **always be the same**!

I agree, it doesnt depend on any external inputs. So lets Optimize it.

&nbsp;

The goal of Optimization is to take in an AST, and output a *semantically equivalent* AST that hopefully involves less calculations.
An optimized version of P would be something like P' = `Print( Int 3 )` 
Every time we run P', it immediately prints out 3 without needing to do any calculation. 

&nbsp;

> Well this is great, why dont we do it for all expressions?

Erm. Some expressions rely on values not known at *compile-time* such as `Print( 2 + 3 + read() )`
We can optimize the result of `2 + 3`, but since we do not know what `read()` will be given, we can not determine this during *compile-time*, and we need to rely on the evaluator to finish the computation during *runtime*
Optimized result: `Print( Binop( Add, Int 5, Value ) )`
&nbsp;

> Yippee now we have more efficient AST's that require less computation every time we run them!


In the first part of this project, you will implement a function `optimize : expr environment -> expr -> expr`,  which can partially evaluate and simplify the AST, using the following optimizations:

### Constant folding

Constant folding is the process of recognizing and evaluating constant expressions at compile-time rather than computing them at runtime. Terms in constant expressions are typically simple literals, such as the integer literal 2, or boolean literal `true`, but they may also be variables whose values are known at compile-time. Consider the expression:

  $$(3 + 4) * 6$$

Without an optimization, the expression `(3 + 4) * 6` will be calculated at run-time. We want to identify constructs such as these and substitute the computed values at compile-time (in this case, `42`).

Constant folding can make use of arithmetic and boolean identities. For example:

* If `x` is numeric, the value of `0 * x` is zero, even if the compiler does not know the value of `x`.
* If `x` is numeric, the value of `x / 0` is is a `DivideByZeroError`.
* If `x` is numeric, the value of `x + 0 - 0` is `x`.
* If `x` is a boolean, then the value of `x && true` is `x`
* If `x` is a boolean, then the value of `x || true` is `true`

There are others you should consider. If you need a refresher on rules of inference and laws of equivalence, refer to our CMSC250 class. ([JWG](https://math.umd.edu/~immortal) (and Cliff's) [notes](https://www.math.umd.edu/~immortal/CMSC250/) and Cliff's [slides](https://bakalian.cs.umd.edu/fall22/250/)).

> [!Important]
> Testing optimization of AST is hard. Our test will look for all `Value` types pushed to the end of the expression, and then be right associative. 
For example:
```ocaml
(* 1 + read() + 2 *)
Binop(Add,Int(3),Value)
(* and not 
Binop(Add,Value,Int(3))
*):

(* read() + read() + 2 + read() + 1) *)
Binop(Add,Int(3),Binop(Add,Value,Binop(Add,Value,Value)))
(* not anything else like
Binop(Add,Int(3),Binop(Add,Binop(Add,Value,Value),Value))
*)
```

### Constant propagation

Constant propagation is the process of substituting the values of known constants in expressions. In SmallC such constants include the int and boolean literals. Consider the following pseudocode:

```C
x = 42;
y = 14 * 3 - x;
if (y = 0){
  1;
} else {
  2;
}
```
Propagating x yields: 
```C
x = 42;
y = 0;
if (y = 0){
  1;
} else {
  2;
}
```
Continuing to propagate yields `1` . 

#### Branch Folding

An extension of Constant Propagation seen above, when we have branching conditions that are known at compile-time, can reduce the branch choice to the constant path that will be taken.

```c
if (true){
  x = 5 + 7;
} else {
  x = 3;
}
```
We know in this case, that the false branch will never be taken. Mixed with constant propagation, we can reduce this statement down to the following:
``` C
x = 12;
```

Additionally, when the two branches are the same, you can remove the branching factor completely.
```c
x = read();
if (x){
  a = 5;
}else{
  a = 5 * 1;
}
```
In this case, no matter what `x` is, we will always get `a = 5`. 

### Looping 

Like branch folding, looping can be taken out completely if the guard to the loop is false. 
For example,
```c
x = true;
while(false){
  print(x)
}
(* can be optimized to just *)
x = true;
NoOp (* Replace it with a NoOp, easier than trying to remove it completely *)
``` 
For `for` loops, the semantics from Project 4 still hold:
$$(\text{for-stop})\ \cfrac{e_1 \Rightarrow n_1\quad e_2\Rightarrow n_2\quad e1 > e2}{A;\text{for}\ (x\ \text{from}\ e_1 \text{to}\ e_2)\{s\} \Rightarrow A,x:n_1;NoOp}$$
So even when the for loop should not execute, the variable should still be set to the starting point.

### Limitations
You will not need to consider the following cases for this project. If you ever get into compiler optimization (or take CMSC430), you will need to.  
**You can assume all ASTs have no type errors.**

#### Loop Unrollowing
Loop unrolling is the process of "unrolloing" a loop. Looping adds a lot of overhead and checks that happen in assembly. The idea of loop unrolling is to make the binary larger but removing the overhead checks
```c
for(x from 1 to 3){
    print(x)
}
```
Can be unrolled to 
```c
print(1);
print(2);
print(3);
```
#### Redundant Assignments
When you have two sequential assignments to the same variable, and no side effects, occur, the first assignment becomes redundant. 
```c
x = 5;
x = 7;
```
This could be optimized to 
```c
x = 7;
```

#### Reaching Definitions
When you have mutable data and allow for if statements with no else clause, you get something like the following:
```c
a = 7;
x = read();
if (x){
  a = 5;
}
print(a);
```
 Here, you cannot substitute `7` for `a` in the last line. This is the idea of `reaching defintion`: a relationship between assignment and usage of variables.
 There are other variations and examples of this. 

 > [!NOTE]
 > We have made all optimization tests public, so if you are wondering if you need to consider or ignore any other type of optimization, you can just check the public test. However, to prevent hardcoding, your copy of the public tests are slightly different than the ones on gradescope.
 
**Again, you can assume all ASTs have no type errors.**


> [!NOTE]
> **How is this optimization different from the evaluator in Project 4?**
> 
> In project 4, every variable had a known value, so we could use some sort of constant propagation. With the addition of `read()` in the AST, there will now be parts that we cannot optimize until runtime. Additionally, with the `printf` statement, we don't want to actually print out anything during this phase. So evaluation is the wrong term to use here. The final difference would be the usage of loops. Optimization should terminate for all programs, even if there is an infinite while loop in the program itself. Our goal is to minimize the AST, not to perform any side effects. 

## Part (B): Type Checker and Inferencer

The main purpose of a type system in a programming language is to reduce possibilities for bugs in the programs due to type errors. To make things interesting, we also need to figure out the types of our variables when we use them. In this part of the project, you will implement a type checker and inferencer for SmallC.

### AST

Below is the AST type `expr`, which is returned by the parser. We have provided the lexer and parser generators (ocamllex, ocamlyacc) for this project. If you wish, you can use your own parser from Project 4, but you will have to update it according to the new AST:
### Type Checker

#### `typecheck : stmt -> bool`

* **Description:** Takes in an AST `stmt`, and type checks the expression in the given environment, returning `true` if the expression passes the type checker. Throw a `TypeError`if it does not. (This does mean it should never return false).
* **Exception:** Throws a `TypeError` if the expression does not type check. 
* **Exception:** Throws a `DeclareError` if there is an unbound variable. 
* **Assumptions:**
  - Every variable name will be unique (no shadowing).
  - The given type in the Ast for any variable will be consistent throughout the same program. 

For example:
```ocaml
typecheck Assign("x",Int_Type,Binop(Add,Int(3),Int(5))) => true
typecheck Assign("y",Bool_Type,Binop(Equals,Int(5),Int(3))) => true
typecheck Assign("z",Bool_Type,Int(4)) => (* TypeError *)
typecheck Assign("x",Int_Type,Binop(Add,Int(3),Bool(true))) => (* TypeError *)
typecheck Assign("y",Int_Type,Binop(Add,Int(3),ID("x"))) => (* DeclareError *)

typecheck Seq(Assign("x",Int_Type,Int(3)),Assign("x",Int_Type,Bool(true))) => (* Type Error *)
typecheck Seq(Assign("x",Bool_Type,Int(3)),Assign("x",Bool_Type,Bool(true))) => (* Type Error *)
typecheck Seq(Assign("x",Unknown_Type(0),Int(3)),Assign("x",Unknown_Type(0),Bool(true))) => true (* see below about Unknown_Type *)
typecheck Seq(Assign("x",Int_Type,Int(3)),Assign("x",Bool_Type,Bool(true))) => (* Will never occur due to second assumption *)
```

#### Unknown_Type
The result type of `Read()` should be an `Unknown_Type`. `Unknown_Type` can be used iterchangabley with `Int_Type` and `Bool_Type`, so the following should all type check:
```ocaml
(* int main(){
    x = read();
  } *)
typecheck Assign("x",Int_Type,Value)
typecheck Assign("x",Bool_Type,Value)
typecheck Assign("x",Unknown_Type(0),Value)

(* int main(){
    x = read();
    y = x && (x + 3)
}*)
typecheck Seq(Assign("x",Unknown_Type(0),Value),
          Assign("y",Bool_Type,Binop(And,ID("x"),Binop(Add,ID("x",Int(3)))))) = true
```
It would be the type inferencer's job to figure out if this is okay or not. 
### Type Inferencer

#### `inference: stmt -> stmt`
* **Description:** Takes in an AST `stmt` with `unknown` types and returns an updated AST with type information. 
* **Exception:** Throws a `TypeError` if there is a type error.
* **Exception:** Throws a `DeclareError` if there is an unbound variable. 
* **Assumptions:**
  - Every variable name will be unique (no shadowing).
* Examples:
```ocaml
(* int main(){x = 5 + 3;} *)
inference (Assign("x",Unknown_Type(0),Add(Int(5),Int(3)))) => (Assign("x",Int_Type,Add(Int(5),Int(3))))

(* int main(){x = true;}*)
inference (Assign("x",Unknown_Type(0),Bool(true))) => (Assign("x",Bool_Type,(Bool(true))))

(* int main(){x = read(); print(x+1)}*)
inference (Seq(Assign("x",Unknown_Type(0),Value),Print(Binop(Add,ID("x"),Int(1))))) => (Seq(Assign("x",Int_Type,Value),Print(Binop(Add,ID("x",Int(1))))))

(* int main(){x = 3;x = true} *)
inference (Seq(Assign("x",Unknown_Type(0),Int(3),Assign("x",Unknown_Type(1),Bool(true))))) => TypeError
```

### Exceptions

We've kept the same list of possible error cases and exceptions from Project 4, but have adapted the cases to meet the new requirements for `optimize`, `typecheck`, and `infer`:

```ocaml
exception TypeError of string
exception DeclareError of string
exception DivByZeroError
```

* A `TypeError` happens when the type checker or type inferencer is unable to validate the type of the input.
* A `DeclareError` happens when there is a unbound variable.
* A `DivByZeroError` happens on attempted division by zero in the optimizer.

> [!NOTE]
> We do not enforce what messages you use when raising a `TypeError` or `DeclareError` That's up to you.

### Ground Rules and Extra Info

As per usual, you may not use any imperative ocaml except for the provided `fresh()` function. You may use library functions found in the Stdlib module, and List module. You are free to define your own typing environment. 

### Testing & Submitting

Submit by running `submit` after pushing your code to GitHub. 

All tests will be run on direct calls to your code, comparing your return values to the expected return values. Any other output (e.g., for your own debugging) will be ignored. We recommend using relevant error messages when raising these exceptions in order to make debugging easier. We are not requiring intelligent messages that pinpoint an error to help a programmer debug, but as you do this project you might find you see where you could add those.

To test from the toplevel, run `dune utop src`. The necessary functions and types will automatically be imported for you.

### Checkout Link
[https://classroom.github.com/a/dFkp554I](https://classroom.github.com/a/dFkp554I)

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. This includes posting this project to GitHub after the course is over. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.
