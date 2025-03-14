# Discussion 7 - Friday, March 14th

## Reminders

1. Project 3 due **TODAY @ 11:59pm**
2. Project 4 released, tentatively due **Thursday, April 2nd @ 11:59pm**
    - We have given ample time to do this project after break, as there is no expectation to work on this project during break.

## Context Free Grammars

### Exercises:

1. Consider the following grammar:

   ```
   S -> S + S | 1 | 2 | 3
   ```

   - Write a leftmost derivation for the string: `1 + 2 + 3`

     - Start with S and use the production rules on the LEFTMOST nonterminal ONE AT A TIME. (For a rightmost derivation, use the productions on the RIGHTMOST nonterminal.)
     - ONE NONTERMINAL AT A TIME!!!! DON'T COMBINE STEPS!!!! (or you might lose credit)

   - If there are 2 leftmost derivations or 2 rightmost for the same string in a grammar, what does that mean?

<details>
  <summary>Solution</summary>

Leftmost Derivation: 
S -> S + S -> S + S + S -> 1 + S + S -> 1 + 2 + S -> 1 + 2 + 3
OR 
S -> S + S -> 1 + S -> 1 + S + S -> 1 + 2 + S -> 1 + 2 + 3

There are two leftmost derivations for this string, which means the grammar is **ambiguous**.

</details>

2. Consider the following grammar:

   ```
   S -> aS | T
   T -> bT | U
   U -> cU | ε
   ```

   - Provide derivations for:

     - b
     - ac
     - bbc

   - What language is accepted by this grammar?

   - Create another grammar that accepts the same language.

<details>
  <summary>Solution</summary>
 
S -> T -> bT -> bU -> b

S -> aS -> aT -> aU -> acU -> ac
    
S -> T -> bT -> bbT -> bbU -> bbcU -> bbc

This is the language of all strings equivalent to the regex `a*b*c*`.

Another grammar that accepts this language is:
```
S -> Sc | T
T -> Tb | U
U -> Ua | ε
```
    
</details>

3. Consider the expression and construct an equivalent CFG:


   $a^xb^xc^y|a^x$ where $x \ge 0$ and $y \ge 1$

<details>
  <summary>Solution</summary>

```
S -> A | B           Union of two languages
A -> CD              Concatenation of two languages
C -> aCb | ε         Related number of 0 or more  a's and b's
D -> cD | c          1 or more c's
B -> aB | ε          0 or more a's
```

</details>
    
4. Consider the following grammars:
   ![image](https://hackmd.io/_uploads/SkK01s2ikl.png)

   - Which grammar accepts both `"aaabb"` and `"aaabbcc"`?
   - Which grammar is ambiguous?

<details>
  <summary>Solution</summary>

Grammar 3 accepts both `"aaabb"` and `"aaabbcc"`.
    
Grammar 2 is ambiguous. For example, the string `"aac"` can be made in two ways.

</details>

5. Construct a CFG that generates strings for each of the following:
   - $a^xb^y$, where $y = 2x$.
   - $a^xb^y$, where $y \ge 3x$.

    Can we represent strings of the form $a^xb^xc^x$, where $x \ge 0$, with CFGs?
    
<details>
  <summary>Solution</summary>

1. 
```
    S -> aSbb | ε
```

2.
```
    S -> aSbbbB | B
    B -> bB | ε
```

We cannot accept strings of the form $a^xb^xc^x$, as there is no way for a CFG to have "memory" of multiple parts of the string, keeping the number of a's and c's equal.
    
</details>
    
## Interpreters
- To go from source code to a running program, there are 3 steps (at least for our purposes):

  - Tokenizing/Lexing (separating text into smaller tokens)
  - Parsing (generating something meaningful from the tokens - an AST)
  - Interpreting (evaluating the result of the AST)

- Consider the following grammar:

  ```
  S -> M + S | M
  M -> N * M | N
  N -> n | (S)

  * where n is any integer
  ```

  - This grammar is right associative/recursive. Why did we provide a right associative grammar? What would you do if we didn't?.

  - What is the relative precedence of the + and \* operators here? How is it determined? How can we use CFGs to enforce precedence?

### Lexer

- Open `lexer.ml`.
- **NOTES:**
  - Take a look at the variant type `token` we have defined
  - Keep an index that keeps track of where we are in the string, and move forward as we keep tokenizing.
  - It's probably also a good idea to just define all the regex's and store in variables at the top.

### Parser

- Open `parser.ml`.
- **NOTES:**
  - Take a look at the variant type `expr` we have defined
  - Use `let rec ... and` to write mutually recursive functions.
  - `lookahead` returns the head of the list.
  - `match` "consumes" the head of the list (provided that the token and head of the list match).
- **IMPORTANT:**
  - We're going to write a function named `parse_X` for each nonterminal `X` in our grammar.
  - Each of these functions will parse (consume) some tokens, and return (1) the unparsed tokens and (2) the AST which corresponds to the parsed tokens.

### Interpreter

- Open `interpreter.ml`.
- **NOTES:**
  - Our `eval` function will take in an AST created by `parser` and evaluate it into an integer
  - Recursion is your friend!

### Exercises:
Consider the following language extended from a previous exam problem (Spring 2023 Exam 2):

```
E ⇒ + E E | - E E | * E E | / E E | sq E | exp E E |
    and E E |or E E | not E | if E E E | N
N ⇒ 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | true | false | null
``` 
1. **Lexing**
    Which would fail the lexing stage for the language provided above? Select all that apply
    - A. `+ 3 * 4 5`
    - B. `if > 5 4 true false`
    - C. `- sq 9 $`
    - D. `sq-2`
    - E. `if @ true false`

<details>
  <summary>Solution</summary>

- B: `>` is not in our grammar
- C: `$` is not in our grammar
- E: `@` is not in our grammar

</details>

2. **Parsing**
    Which would fail the parsing stage for the language provided above? If it fails the lexing stage, then do not choose it.
    - A. `+ 3 * 4 5`
    - B. `if > 5 4 true false`
    - C. `- sq 9 $`
    - D. `sq-2`
    - E. `if @ true false`

<details>
  <summary>Solution</summary>

- D: `sq-2` is not properly structured. The grammar requires a space between sq and its argument.
- B, C, and E already failed at the lexing stage.

</details>

3. **Evaluation**
    Which would fail the evaluation stage for the language provided above? If it fails the lexing or parsing stage, then do not choose it.
    - A. `+ 3 * 4 5`
    - B. `if > 5 4 true false`
    - C. `/ 4 0`
    - D. `+ null 3`
    - E. `and 5 true`

<details>
  <summary>Solution</summary>

- C: Division by zero is a runtime error
- E: Type error: and requires both operands to be boolean, but 5 is a number

</details>

## Resources & Additional Readings

- [Cliff's Notes on Grammars](https://bakalian.cs.umd.edu/assets/notes/grammars.pdf)
- [Anwar's Parsing Slides](https://bakalian.cs.umd.edu/assets/slides/16-parsing1.pdf)
