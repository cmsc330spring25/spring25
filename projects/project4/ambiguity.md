# CFG: From Ambiguity to Right Recursive Addendum

For this project, you have been tasked with writing a recursive descent parser.
However, as discussed in the README, the CFGs we provided to describe the language had to be written in a way such that they could be parsed by a recursive descent parser.
This requires making them right-recursive and right-associative. We need to make it right-recursive and
not left-recursive because trying to write a recursive descent parser for a left-recursive grammar results in an infinite loop, as seen
on the [lecture slides](https://bakalian.cs.umd.edu/330/slides).

A more intuitive but ambiguous CFG is shown below:

- Expr -> OrExpr
- OrExpr -> OrExpr `||` OrExpr | AndExpr
- AndExpr -> AndExpr `&&` AndExpr | EqualityExpr
- EqualityExpr -> EqualityExpr EqualityOperator EqualityExpr | RelationalExpr
  - EqualityOperator -> `==` | `!=`
- RelationalExpr -> RelationalExpr RelationalOperator RelationalExpr | AdditiveExpr
  - RelationalOperator -> `<` | `>` | `<=` | `>=`
- AdditiveExpr -> AdditiveExpr AdditiveOperator AdditiveExpr | MultiplicativeExpr
  - AdditiveOperator -> `+` | `-`
- MultiplicativeExpr -> MultiplicativeExpr MultiplicativeOperator MultiplicativeExpr | PowerExpr
  - MultiplicativeOperator -> `*` | `/`
- PowerExpr -> PowerExpr `^` PowerExpr | UnaryExpr
- UnaryExpr -> `!` UnaryExpr | PrimaryExpr
- PrimaryExpr -> *`Tok_Int`* | *`Tok_Bool`* | *`Tok_ID`* | `(` Expr `)`

Before we start, it is important to note that we must be careful with precedence when changing the grammar. Currently, the grammar is
defining a certain precedence, and we must ensure to retain that precedence. In order to do so, we will ensure that we do not change “levels” of the expressions/operators somehow with our refactoring. For example, `*` is further from the start than `+` in the above grammar, so we must have that be the case in our new grammar.

To refactor the grammar, we need to first find the source of the ambiguity. Starting with Expr, the first rule is `Expr -> OrExpr`. There is clearly no ambiguity here, as there is only one option. Next we have OrExpr -> OrExpr `||` OrExpr | AndExpr. This rule is ambiguous because in the OrExpr `||` OrExpr
portion, there is no way to determine which OrExpr to pick since they have the same effect.

To show this ambiguity we can show the beginning of two leftmost derivations:
 - Expr -> OrExpr -> OrExpr || OrExpr -> AndExpr || OrExpr -> ... -> true || OrExpr -> true || OrExpr || OrExpr -> ...
 - Expr -> OrExpr -> OrExpr || OrExpr -> OrExpr || OrExpr || OrExpr -> AndExpr || OrExpr || OrExpr -> ... -> true || OrExpr || OrExpr -> ...

 As can be seen, the derivations took a different turn on the 4th step but resulted in the same string later on. Looking at the remainder
 of the rules, we can see many of this form `S -> S op S` where S is replaced by whatever rule it is and op is replaced by the operator in
 that rule (which could be nothing). Thus, many of the rules are ambiguous.

 In order to remove ambiguity, we have to force the choice of which side to pick. Because we know that left-recursive grammars cannot be parsed
 with a recursive descent parser, we need to force the choice that results in a right-recursive grammar (one that has a recursive step on the
 RIGHT side). Looking at the two derivations above, the right-recursive one is the first one. The left OrExpr did not recurse and
 became an AndExpr, and the right OrExpr recursed and became another OrExpr || OrExpr.

 In order to take the choice away, all we need to do is make the left OrExpr what it would be if it did not recurse, which is an AndExpr.
 This turns the rule into:

 OrExpr -> AndExpr `||` OrExpr | AndExpr

 The same process can be done for the rest of the rules, each time changing the left-hand expression into the next rule down. Doing so for
 all the rules results in the following CFG:

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

 Note that the first rule and the last two rules did not need to be changed since they were not of form `S -> S op S`. While there are
 other forms of ambiguity, this grammar only displayed ambiguity of that form.

---

Next we move onto the statement CFG. An ambiguous CFG for statements is as follows:

- Stmt -> Stmt Stmt | DeclareStmt | AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt | ε
  - DeclareStmt -> BasicType ID `;`
    - BasicType -> `int` | `bool`
  - AssignStmt -> ID `=` Expr `;`
  - PrintStmt -> `printf` `(` Expr `)` `;`
  - IfStmt -> `if` `(` Expr `)` `{` Stmt `}` ElseBranch
    - ElseBranch -> `else` `{` Stmt `}` | ε
  - ForStmt -> `for` `(` ID `from` Expr `to` Expr `)` `{` Stmt `}`
  - WhileStmt -> `while` `(` Expr `)` `{` Stmt `}`

First we will look for ambiguity of the form `S -> S op S` like we did for the expression CFG. Looking at the first rule, we have
Stmt -> Stmt Stmt | DeclareStmt | AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt. The last five are of the same form as Expr -> OprExpr,
which is clearly unambiguous, as it is just a direct replacement with no choices. However, the first one, Stmt -> Stmt Stmt is different.
If you have 3 statements, how are you to know which Stmt in the rule should be 1 and which should recurse and be 2? This is definitely
ambiguous. Looking closer, we can see that it is actually of the form `S -> S op S` where op is nothing, or epsilon. Thus, we can apply
the same concept as we did for expressions.

However, there is one problem. With expressions, there was only 1 option for what it would be if it did not recurse, but in this case
there are 5 options. The solution to this is to make a new rule that does what the EqualityOperator and RelationalOperator did in expression,
which is to make one rule to cover all 5 cases. Once we do that, we can replace the 5 cases with that one rule, and it will be like
expression and have only 1 option.

The new rule is as follows:

StmtOptions -> DeclareStmt | AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt

Now that we have this, we can re-write the first rule as the following:

Stmt -> Stmt Stmt | StmtOptions

Once it is in this form, we can do exactly what we did with the expression and change the left Stmt to the next rule down, StmtOptions.
Doing so results in the following grammar:

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

Looking at the rest of the rules we can determine that there is no more ambiguity. Thus, this concludes our transformation process.
You are now ready to begin coding using the refactored CFGs.

Note: For statement it is possible to account for the ambiguity that comes from multiple statements in the coding process instead of by is as follows:
transforming the grammar. One way to do this is to ALWAYS assume there is a second statement and try to parse it recursively. If the lookup is a `}` (that is not inside a statement) or `EOF` then say the current statement is NoOp and return. By doing this, you can make parse_stmt into 1 recursive function instead of many functions.
