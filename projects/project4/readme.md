# Project 4: SmallC Lexer, Parser, and Evaluator
Due: Thursday, April 3rd, 11:59 PM EST (Late: Friday, April 4th 11:59 PM EST)

Points: 48 public, 52 semipublic

## Introduction

In this project, you will implement as OCaml functions a lexer and parser for SmallC. Your lexer functions will convert a SmallC program internally stored as a string into a list of tokens, and your parser functions will consume these tokens to produce an abstract symbol tree (AST). The input could be an entire program or a fragment of a program, and your parser will produce an AST that represents one or more statements (stmt) or an expression (expr). This readme describes the tokens and grammar you will use.

The only requirement for error handling is that input that cannot be lexed/parsed according to the provided rules should raise an InvalidInputException. We recommend using relevant error messages when raising these exceptions to make debugging easier. We are not requiring intelligent messages that pinpoint an error to help a programmer debug, but as you do this project, you might find you see where you could add those.

All tests will be run on direct calls to your code, comparing your return values to the expected return values. Any other output (e.g., for your own debugging) will be ignored. You are free and encouraged to have additional output.

Here is an example SmallC program:

```c
int x;
x = 2 * 3 ^ 5 + 4;
printf(x > 100);
```

An example use of the parser in Utop:

```ocaml
parse_stmt (tokenize "int x; x = 2 * 3 ^ 5 + 4; printf(x > 100);")
```

### Ground Rules

In your code, you may use any non-imperative features from the List, Stdlib, String, and Re modules. **Imperative Ocaml is not allowed.** 

### Testing & Submitting

Submitting to Gradescope can be done using the same method used for project 0. Add your changes, commit them, push them, and run the `submit` command.

To test locally, run `dune runtest -f`. Besides the provided public tests, you will also find the file `student.ml` in `test/student/`, where you'll be able to add `OUnit` tests of your own.

You can run your lexer or parser directly on a SmallC program by running `dune exec bin/interface.bc lex [filename]` or `dune exec bin/interface.bc parse [filename]` where the `[filename]` argument is required.

To test from the toplevel, run `dune utop src`.  The necessary functions and types will automatically be imported for you.

All of our tests will feed C code into your program to be lexed and parsed.  You can write your own tests which only test the parser by feeding it a custom token list.  For example, to see how the expression `1 + 2 ^ 3 * 4` would be parsed, you can construct the token list manually (e.g. in Utop):

```ocaml
parse_expr [Tok_Int 1; Tok_Add; Tok_Int 2; Tok_Pow; Tok_Int 3; Tok_Mult; Tok_Int 4; EOF];;
```

This way, you can work on the parser even if your lexer is not complete yet.

## Part 1: The Lexer (aka Scanner or Tokenizer)

Before your parser can process input, the raw file must be transformed into logical units called tokens. The goal is to transform a SmallC program, represented as a string, into a list of tokens that capture the different elements of the program. This process is readily handled by use of regular expressions. Information about OCaml's regular expressions library can be found in the [`Re` module documentation][re doc]. You aren't required to use it, but you may find it very helpful. Note that a lexer is the same as a scanner, which is discussed in the lecture slides.

Your lexer must be written in `lexer.ml`. You will need to implement the following function: 

#### `tokenize`

- **Type:** `string -> token list` 
- **Description:** Converts SmallC source code (given as a string) to the associated token list.
- **Examples:**
  ```ocaml
  tokenize "1 + 2" = [Tok_Int 1; Tok_Add; Tok_Int 2; EOF]
  tokenize "" = [EOF]
  tokenize "int main() { int x; }" = [Tok_Int_Type; Tok_Main; Tok_LParen; Tok_RParen; Tok_LBrace; Tok_Int_Type; Tok_ID "x"; Tok_Semi; Tok_RBrace; EOF]
  ```

The `token` type is implemented in `tokenTypes.ml`.

A few important notes to consider:
- Tokens can be separated by arbitrary amounts of whitespace, which your lexer should discard. Spaces, tabs ('\t') and newlines ('\n') are all considered whitespace.
- The lexer should be case sensitive.
- Lexer output should be terminated by the `EOF` token, meaning that the shortest possible output from the lexer is `[EOF]`.
- If the beginning of a string could be multiple things, the **longest** match should be preferred, for example:
  - "while0" should not be lexed as `Tok_While`, but as `Tok_ID("while0")`, since it is an identifier.
  - "1-1" should be lexed as `Tok_Int(1)` and `Tok_Int(-1)`, since "-1" is a valid integer.

Most tokens only exist in one form (for example, the only way for `Tok_Pow` to appear in the program is as `^` and the only way for `Tok_While` to appear in the program is as `while`). However, a few tokens have more complex rules. The regular expressions for these more complex rules are provided here:

- `Tok_Bool of bool`: The value will be set to `true` on the input string "true" and `false` on the input string "false".
  - *Regular Expression*: `true|false`
- `Tok_Int of int`: Valid ints may be positive or negative and consist of 1 or more digits. You may find the function `int_of_string` useful in lexing this token type.
  - *Regular Expression*: `-?[0-9]+`
- `Tok_ID of string`: Valid IDs must start with a letter and can be followed by any number of letters or numbers. Note that keywords may be contained within IDs and they should be counted as IDs unless they perfectly match a keyword!
  - *Regular Expression*: `[a-zA-Z][a-zA-Z0-9]*`
  - *Valid examples*:
    - "a"
    - "ABC"
    - "a1b2c3DEF6"
    - "while1"
    - "ifelsewhile"

In grammars given later in this project description, we use the lexical representation of tokens instead of the token name; e.g. we write `(` instead of `Tok_LParen`. This table shows all mappings of tokens to their lexical representations, excluding the three literal token types specified above:

Token Name (in OCaml) | Lexical Representation (in grammars below)
--- | ---
`Tok_LParen` | `(`
`Tok_RParen` | `)`
`Tok_LBrace` | `{`
`Tok_RBrace` | `}`
`Tok_Equal` | `==`
`Tok_NotEqual` | `!=`
`Tok_Assign` | `=`
`Tok_Greater` | `>`
`Tok_Less` | `<`
`Tok_GreaterEqual` | `>=`
`Tok_LessEqual` | `<=`
`Tok_Or` | `\|\|`
`Tok_And` | `&&`
`Tok_Not` | `!`
`Tok_Semi` | `;`
`Tok_Int_Type` | `int`
`Tok_Bool_Type` | `bool`
`Tok_Print` | `printf`
`Tok_Main` | `main`
`Tok_If` | `if`
`Tok_Else` | `else`
`Tok_For`  | `for`
`Tok_From`  | `from`
`Tok_To`  | `to`
`Tok_While` | `while`
`Tok_Add` | `+`
`Tok_Sub` | `-`
`Tok_Mult` | `*`
`Tok_Div` | `/`
`Tok_Pow` | `^`

Your lexing code will feed the tokens into your parser, so a broken lexer can cause you to fail tests related to parsing.

## Part 2: The Parser

Once the program has been transformed from a string of raw characters into more manageable tokens, you're ready to parse. The parser consists of three main functions that parse expressions, statements, and an entire program (`parse_expr`, `parse_stmt` and `parse_main`.) The three work together to parse a full program.

Each takes a stream of tokens and outputs an OCaml variant type representing an AST for the input. The type definitions corresponding to each type of AST and their associated grammars are [specified below](#important-considerations-for-cfgs). The type definitions can also be found in `smallCTypes.ml`. In the case of `parse_expr`, the root is type `expr`; for `parse_stmt`, type `stmt`; and `parse_main`, type `stmt` again (since the main function in SmallC just holds a list of statements). You can and should write `parse_expr` and `parse_stmt` in that order to test them on small fragments of SmallC, but the parser is ultimately initiated by a call to `parse_main`.

The three functions are specified below:

#### `parse_expr`

- **Type:** `token list -> token list * expr`
- **Description:** Takes a list of tokens and returns an AST representing the expression corresponding to the given tokens, along with the new, reduced list of tokens.
- **Exceptions:** If the next tokens in the token list do not represent an expression, raise `InvalidInputException`.
- **Examples:**
  ```ocaml
  parse_expr [Tok_Int(1); Tok_Add; Tok_Int(2); Tok_Semi; EOF] = ([Tok_Semi; EOF], Add (Int 1, Int 2))
  parse_expr [Tok_Int(1); EOF] = ([EOF], Int 1)
  parse_expr [Tok_Int_Type; EOF] (* InvalidInputException *)
  ```

#### `parse_stmt`

- **Type:** `token list -> token list * stmt`
- **Description:** Takes a list of tokens and returns an AST representing the statement corresponding to the given tokens, along with the new, reduced list of tokens
- **Exceptions:** If the next tokens in the token list do not represent a statement, raise `InvalidInputException`.
- **Examples:**
  ```ocaml
  parse_stmt [Tok_Int_Type; Tok_ID("x"); Tok_Semi; EOF] = ([EOF], Seq (Declare (Int_Type, "x"), NoOp))
  parse_stmt [Tok_ID("x"); Tok_Assign; Tok_Int(3); Tok_Semi; EOF] = ([EOF], Seq (Assign ("x", Int 3), NoOp))
  parse_stmt [Tok_Int(3); Tok_Add; Tok_Int(4); EOF] (* InvalidInputException *)
  ```

#### `parse_main`

- **Type:** `token list -> stmt`
- **Description:** Takes a list of tokens and returns an AST representing the list of statements in the body of the `main` function.  All tokens should be consumed, so there is no need to return the remaining tokens.
- **Exceptions:** If the list of tokens does not contain only `EOF` at the end, raise `InvalidInputException`.  Also, if the token list contains tokens before the beginning of the `main` function declaration, or after it's last closing brace, or if the `main` function doesn't exist in the token list, raise `InvalidInputException`.
- **Examples:**
  ```ocaml
  parse_main [Tok_Int_Type; Tok_Main; Tok_LParen; Tok_RParen; Tok_LBrace; Tok_Int_Type; Tok_ID("x"); Tok_Semi; Tok_RBrace; EOF] = Seq (Declare (Int_Type, "x"), NoOp)
  parse_main [Tok_Int(3); Tok_Add; Tok_Int(4); EOF] (* InvalidInputException *)
  ```

The parser must be implemented in `parser.ml` in accordance with the signatures found in `parser.mli`. `parser.ml` is the only file you will write code in. The functions should be left in the order they are provided, as a good implementation will rely heavily on earlier functions.

**Note**: we have provided the function `match_token` which takes the list of tokens and a single token as arguments, and will either:
- Return a new token list with the first token removed IF the first token matches the second argument, or
- Raise an exception IF the first token does not match the second argument to the function.

We have also provided the `lookahead` function which returns the first token in the list of tokens, but does NOT modify the token list.  This function will raise an exception if the token list is empty.

### **Important Considerations for CFGs**

We provide a CFG below for the language of C expressions. This CFG is right-recursive, so something like `1 + 2 + 3` will parse as `Add (Int 1, Add (Int 2, Int 3))`, essentially implying parentheses in the form `(1 + (2 + 3))`.) As convention, in the given CFG all non-terminals are capitalized, all syntax literals (terminals) are formatted `as non-italicized code` and will come in to the parser as tokens from your lexer. Variant token types (i.e. `Tok_Bool`, `Tok_Int`, and `Tok_ID`) will be printed *`as italicized code`*.

### Part 2.1 `parse_expr`

Expressions represent mathematical and boolean formulas that typically evaluate to either an integer or a boolean. Because expressions are a self-contained subset of the SmallC grammar, we can implement them first, and build the rest of the language on top of them later.

```ocaml
type expr =
  | ID of string
  | Int of int
  | Bool of bool
  | Add of expr * expr
  | Sub of expr * expr
  | Mult of expr * expr
  | Div of expr * expr
  | Pow of  expr * expr
  | Greater of expr * expr
  | Less of expr * expr
  | GreaterEqual of expr * expr
  | LessEqual of expr * expr
  | Equal of expr * expr
  | NotEqual of expr * expr
  | Or of expr * expr
  | And of expr * expr
  | Not of expr
```

The CFG of expressions, from which you should produce a value of `expr` AST type, is as follows:

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
- PrimaryExpr -> *`Tok_Int`* | *`Tok_Bool`* | *`Tok_ID`* | `(` Expr `)`

**For more information on how we constructed this CFG, see [ambiguity.md](./ambiguity.md).  We encourage you to familiarize yourself with this process.**

As an example, see how the parser will break down an input mixing a few different operators with different precedence:

**Input:**
```c
4 / 2 ^ 1 - 0
```

**Output (after lexing and parsing):**
```ocaml
Add(
  Div(
    Int(4),
    Pow(
      Int(2),
      Int(1))),
  Int(0))
```

### Part 2.2 `parse_stmt`

The next step to parsing is to build statements up around your expression parser. When parsing, a sequence of statements should be terminated as a `NoOp`, which you will remember as a do-nothing instruction from the interpreter. Recall the `stmt` type:

```ocaml
type stmt =
  | NoOp
  | Seq of stmt * stmt
  | Declare of data_type * string
  | Assign of string * expr
  | If of expr * stmt * stmt
  | For of string * expr * expr * stmt
  | While of expr * stmt
  | Print of expr
```

The `stmt` type isn't self-contained like the `expr` type, and instead refers both to itself and to `expr`; use your `parse_expr` function to avoid duplicate code! Again, we provide a CFG for you to refer to when building your parser:

- Stmt -> StmtOptions Stmt | ε
  - StmtOptions -> DeclareStmt | AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt
    - DeclareStmt -> BasicType ID `;`
      - BasicType -> `int` | `bool`
    - AssignStmt -> ID `=` Expr `;`
    - PrintStmt -> `printf` `(` Expr `)` `;`
    - IfStmt -> `if` `(` Expr `)` `{` Stmt `}` ElseBranch
      - ElseBranch -> `else` `{` Stmt `}` | ε
    - ForStmt -> `for` `(` ID `from` Expr `to` Expr `)` `{` Stmt `}`
    - WhileStmt -> `while` `(` Expr `)` `{` Stmt `}`

**As with the expression grammar, the process we used to enable the grammar to be parsable can be found in [ambiguity.md](./ambiguity.md).**

If we expand on our previous example, we can see how the expression parser integrates directly into the statement parser:

**Input:**
```c
int x;
x = 2 * 3 ^ 5 + 4;
printf(x > 100);
```

**Output (after lexing and parsing):**
```ocaml
Seq(Declare(Int_Type, "x"),
Seq(Assign("x",
  Add(
    Mult(
      Int 2,
      Pow(
        Int 3,
        Int 5)),
    Int 4)),
Seq(Print(Greater(ID "x", Int 100)), NoOp)))
```

**Input:**
```c
int main(){
  int a;
  for (a from 1 to 10){
    printf(a);
  }
}
```

**Output:**
```ocaml
(Seq
  (Declare (Int_Type, "a"),
   Seq (For ("a", Int 1, Int 10, Seq (Print (ID "a"), NoOp)),
        NoOp)))
```

### Part 2.3 `parse_main`

The last and shortest step is to have your parser handle the function entry point. This is where `parse_main : token list -> stmt` comes in. This function behaves the exact same way as `parse_stmt`, except for two key semantic details:
- `parse_main` will parse the function declaration for main, not just the body.
- `parse_main` validates that a successful parse terminates in `EOF`. A parse not ending in `EOF` should raise an `InvalidInputException` in `parse_main`. As such, `parse_main` does NOT return remaining tokens, since it validates ensures that the token list is emptied by the parse.

The grammar for this parse is provided here:

- Main -> `int` `main` `(` `)` `{` Stmt `}` `EOF`

For this slightly modified input to the example used in the previous two sections, the exact same output would be produced:

**Input:**
```c
int main() {
  int x;
  x = 2 * 3 ^ 5 + 4;
  printf(x > 100);
}
```

The output is the exact same as in the statement parser, but `parse_main` also trims off the function header and verifies that all tokens are consumed.

## Part 3: The Evaluator

In this part, you will implement an interpreter for SmallC. The language supports variables, `int` and `bool` types, equality and comparison operations, math and boolean operations, control flow, and printing, all while maintaining static type safety and being Turing complete.

The language consists of expressions of the `expr` type and statements of the `stmt` type. These algebraic types can be used to represent the full space of well-formed SmallC programs. Their definitions are found [above](#important-considerations-for-cfgs) and in the `smallCTypes.ml` file. This file should be a constant reference to the data types involved in successfully working with SmallC.

### Ground Rules and Extra Info

As per parts 1 and 2, you may use **any** non-imperative standard library functions (with the exception of printing), but the ones that will be useful to you will be found in the [`Stdlib` module][stdlib doc] and the [`List` module][list doc].

**You still may not use any imperative structures of OCaml such as references or the `Hashtbl` module.**

### Compilation, Tests, and Running

You can run the SmallC interpreter directly on a SmallC program by running `dune exec bin/interface.bc -- <filename>`. This driver reads in a program from a file and evaluates the code, outputing the results of any print statements present in the source file. 

If you would like more detailed information about what your code produced, running `dune exec bin/interface.bc -- <filename> -R` provides a report on the final variable bindings as reported by your evaluator. If you would like to see the data structure that is being generated by the parser and fed into your interpreter, run `dune exec bin/interface.bc -- <filename> -U` and our `Utils` module will translate the data structure into a string and print it out for you. Use the `interface` executable to your advantage when testing; that's why we're providing it!

### The Evaluator

*The evaluator must be implemented in `eval.ml` in accordance with the signatures for `eval_expr` and `eval_stmt` found in `eval.mli`. `eval.ml` is the only file you will write code in. The functions should be left in the order they are provided, as your implementation of `eval_stmt` will rely on `eval_expr`.*

The heart of SmallC is your evaluator. We have already implemented `Lexer` and `Parser` modules that deal with constructing tokens and creating the AST out of a program. Where your code picks up is with a representation of SmallC programs as OCaml datatypes, which you are then responsible for evaluating according to the rules below. A program is made up of a series of statements and expressions:

- Statements represent the structure of a program - declarations, assignments, control flow, and prints in the case of SmallC. - Expressions represent operations on data - variable lookups, mathematical and boolean operations, and comparison. Expressions can't affect the environment and as a result only return a `value` containing the value of the expression.

You are responsible for implementing two functions, `eval_expr` and `eval_stmt` in that order. Each of these takes as an argument an `environment` (given in `smallCTypes.ml`) that is an association list. An association list is a list of pairs (2-tuples) where the key is the first element of the pair and the value is the second element. Elements earlier in the list override elements later in the list. In our case, the association list is of type `(string * value) list` where the string is the id name and the value is the current value of that id. **The List module has many useful functions for working with association lists**. Statements may change the values of variables, so `eval_stmt` returns a possibly updated environment.

A formal operational semantics of SmallC can be found in [`semantics.pdf`][semantics document]. We highly recommend you read this document as you work to clear up any possible ambiguity introduced by the English explanations below. The formal semantics do not, however, define error cases such as addition between a boolean and an integer and therefore represent a stuck reduction. The expected behavior for these irreducible error cases are defined only in this document and can be boiled down to the following rules:

- Any expression containing division by zero should raise a `DivByZero` error when evaluated.
- Any expression or statement that is applied to the wrong types should raise a `TypeError` exception when evaluated, for example, the expression `1 + true` would result in `TypeError`.
- An expression or statement that redefines an already defined variable, assigns to an undefined variable, or reads from an undefined variable should raise a `DeclareError` when evaluated.

We do not enforce what messages you use when raising the `TypeError` or `DeclareError` exceptions; that's up to you. Evaluation of subexpressions should be done from left to right, as specified by the semantics, in order to ensure that lines with multiple possible errors match up with our expected errors.

### Part 3.1 `eval_expr`

- **Type:** `environment -> expr -> value` 
- **Description:** Takes an environment `env` and an expression `e` and produces the result of _evaluating_ `e`, which is something of type `value` (`Int_Val` or `Bool_Val`).

#### Int

Integer literals evaluate to a `Int_Val` of the same value.

#### Bool

Boolean literals evaluate to a `Bool_Val` of the same value.

#### ID

An identifier evaluates to whatever value it is mapped to by the environment. Should raise a `DeclareError` if the identifier has no binding.

#### Add, Sub, Mult, Div, and Pow

*These rules are jointly classified as BinOp-Int in the formal semantics.*

These mathematical operations operate only on integers and produce a `Int_Val` containing the result of the operation. All operators must work for all possible integer values, positive or negative, except for division, which will raise a `DivByZeroError` exception on an attempt to divide by zero. If either argument to one of these operators evaluates to a non-integer, a `TypeError` should be raised. For exponentiation, if the operation would give you back a non-integer, you should floor it.

#### Or and And

*These rules are jointly classified as BinOp-Bool in the formal semantics.*

These logical operations operate only on booleans and produce a `Bool_Val` containing the result of the operation. If either argument to one of these operators evaluates to a non-boolean, a `TypeError` should be raised.

#### Not

The unary not operator operates only on booleans and produces a `Bool_Val` containing the negated value of the contained expression. If the expression in the `Not` is not a boolean (and does not evaluate to a boolean), a `TypeError` should be raised.

#### Greater, Less, GreaterEqual, LessEqual

*These rules are jointly classified as BinOp-Int in the formal semantics*

These relational operators operate only on integers and produce a `Bool_Val` containing the result of the operation. If either argument to one of these operators evaluates to a non-integer, a `TypeError` should be raised.

#### Equal and NotEqual

These equality operators operate both on integers and booleans, but both subexpressions must be of the same type. The operators produce a `Bool_Val` containing the result of the operation. If the two arguments to these operators do not evaluate to the same type (i.e. one boolean and one integer), a `TypeError` should be raised.

### Part 3.2 `eval_stmt`

- **Type:** `environment -> stmt -> environment` 
- **Description:** Takes an environment `env` and a statement `s` and produces an updated `environment` (defined in `smallCTypes.ml`) as a result. This environment is represented as `a` in the formal semantics but will be referred to as the environment in this document.

#### NoOp

`NoOp` is short for "no operation" and should do just that - nothing at all. It is used to terminate a chain of sequence statements and is much like the empty list in OCaml in that way. The environment should be returned unchanged when evaluating a `NoOp`.

#### Seq

The sequencing statement is used to compose whole programs as a series of statements. When evaluating `Seq`,  evaluate the first substatement under the environment `env` to create an updated environment `env'`. Then, evaluate the second substatement under `env'`, returning the resulting environment.

#### Declare

The declaration statement is used to create new variables in the environment. If a variable of the same name has already been declared, a `DeclareError` should be raised. Otherwise, if the type being declared is `Int_Type`, a new binding to the value `Int_Val(0)` should be made in the environment. If the type being declared is `Bool_Type`, a new binding to the value `Bool_Val(false)` should be made in the environment. The updated environment should be returned.

#### Assign

The assignment statement assigns new values to already-declared variables. If the variable hasn't been declared before assignment, a `DeclareError` should be raised. If the variable has been declared to a different type than the one being assigned to it, a `TypeError` should be raised. Otherwise, the environment should be updated to reflect the new value of the given variable, and an updated environment should be returned.

#### If

The `if` statement consists of three components - a guard expression, an if-body statement, and an else-body statement. The guard expression must evaluate to a boolean - if it does not, a `TypeError` should be raised. If it evaluates to true, the if-body should be evaluated. Otherwise, the else-body should be evaluated instead. The environment resulting from evaluating the correct body should be returned.

#### While

The while statement consists of two components - a guard expression and a body statement. The guard expression must evaluate to a boolean - if it does not, a `TypeError` should be raised. If it evaluates to `true`, the body should be evaluated to produce a new environment, and the entire loop should then be evaluated again under this new environment, returning the environment produced by the reevaluation. If the guard evaluates to `false`, the current environment should simply be returned.

*The formal semantics rule for while loops is particularly helpful!*

#### For

The for statement will contain four components: an ID, a starting expression, an ending expression, and a body statement. The starting and ending expressions should both evaluate to an integer value that will be used as the start value for your ID, and the ending point of the loop respectively (inclusive). If either of the expressions do not evaluate to an integer, then you should raise a `TypeError`.

On each iteration of the for loop, you should evaluate the body statement. This evaluation will result in a new environment, under which the following iteration of the loop will be evaluated. Note that the `for` loop for our language is self-incrementing, meaning that the ID will be incremented by one at the end of the loop (with any other changes made to the ID or other variables from within the body being respected). The current environment will be returned in the case that the value is not within the range as defined by the starting and ending expressions.

#### Print

The print statement is your project's access to standard output. First, the expression to `print` should be evaluated. Print supports both integers and booleans. Integers should print in their natural forms (i.e. printing `Int_Val(10)` should print "10". Booleans should print in plaintext (i.e. printing `Bool_Val(true)` should print "true" and likewise for "false"). Whatever is printed should always be followed by a newline.


> [!CAUTION]
> If you attempt to print with `print_string`, `print_int`, etc... you will fail any test that checks your output.\
> Only printing performed through the following wrapper functions will be evaluated by the test system, and as a result should be used exclusively with `Print`. The supplied print wrappers which you *must use in place of the built-in print functions for any and all output resulting from `Print` statements and for nothing else* are as follows:
> - `print_output_string : string -> unit`
> - `print_output_int : int -> unit`
> - `print_output_bool : bool -> unit`
> - `print_output_newline : unit -> unit`
>   
> This is because we do not directly intercept your output, but rather have implemented some wrapper functions in the `Utils` for program printing (do not remove `open Utils` from the top of `eval.ml`!). As a result, your code may have any amount of `print_string` statements and it **WILL NOT** be seen the tests. This means that you may use the standard print functions (e.g. `print_string`) for debugging purposes without messing up the tests.  


## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

# Checkout link
[https://classroom.github.com/a/Y2VFExCC](https://classroom.github.com/a/Y2VFExCC)

[re doc]: https://ocaml.org/p/re/latest/doc/Re/index.html
[list doc]: https://ocaml.org/manual/5.2/api/List.html
[stdlib doc]: https://ocaml.org/manual/5.2/api/Stdlib.html

[semantics document]: semantics.pdf 

