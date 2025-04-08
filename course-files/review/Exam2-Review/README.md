# Exam 2 Review Session

## Sections
- [NFA-DFA](#nfa-dfa)
- [Operational Semantics](#operational-semantics)
- [Type Checking](#type-checking)
- [CFGs](#cfgs)
- [Lexers, Parsers, Interpreters](#interpreters)
- [Debugging](#debugging-requested-by-piazza)

## NFA-DFA
### Classifying FSMs (DFA vs. NFA)
FSMs can be classified based on whether they are deterministic.
- **DFA** (Deterministic Finite Automata)
  - "Deterministic" means that the exact output state given any given input state and symbol is pre-*determined*.
  - This means at any given state with any given input, there is **no ambiguity** as to what state comes next.
    - DFAs **cannot have epsilon transitions**.
      <details>
      <summary>Why?</summary>
      If they did, then it would be ambiguous whether the machine should be at the current state or at a state it can reach using an epsilon transition(s).
      </details>
    - DFAs **cannot have more than one transition with the same symbol out of the same state**.
      <details>
      <summary>Why?</summary>
      If they did, then it would be ambiguous which path the machine should follow when given that symbol as input.
      </details>
- **NFA ( Nondeterministic Finite Automata )**
  - "Non-deterministic" means that the exact output state from any given input state and symbol may **not** be uniquely pre-determined.
  - This means at any given state with any given input, there **may be ambiguity** as to what state comes next.
  -   <details>
      <summary> Is every DFA an NFA (or vice versa)?</summary>
       Since DFAs are more restrictive, every DFA is also considered an NFA, but not every NFA is a DFA. In short, "All DFAs are NFAs, but not all NFAs are DFAs".
      </details>

What's the difference in practice? 
- Due to a potentially exponential number of output possibilities, it is generally **more expensive** to check for string acceptance in NFAs.
  - We must check to verify if *any* possible path leads to an accepting state. If any path does, the NFA is considered to accept that string.
- Therefore, computationally, if one needs to quickly query an FSM/NFA many times, it may be best to convert it to a DFA beforehand.

### ε-closure
- Take as input an NFA and the current state.
- Return the set of all the states that we can visit from the current state using **any number of ε-transitions** (including 0).
    - We only consider ε-transitions and no other symbol.
    ![IMG_06454F32841E-1 (1)](./imgs/6e35a89b-852b-4e70-904a-59b62eaf8571.png)

### move
- Take as input an NFA, the current state, and a symbol.
- Return the set of all the states that we can visit from the current state using **exactly one transition** on that symbol.
    - On the project, we define move on an ε the same way - set of states reachable using exactly one *explicit* ε-transition.
    ![IMG_97532BCB6B36-1 (1)](./imgs/d1624135-0d6f-4866-8a08-56e87db3670b.png)

### NFA to DFA
Conversion algorithm:

| As seen in disucussion 5  | In other words... |
| ------------- | ------------- |
| Input: $\text{NFA}(\Sigma, Q, q_0, F_n, \delta)$  | Input: NFA
Output: $\text{DFA}(\Sigma, R, r_0, F_d, \delta')$  | Output: DFA
Let $r_0$ = $\varepsilon\text{-closure}(\delta, q_0)$, add it to $R$ | Let the starting state of the DFA ($r_0$) equal the ε-clousre of the starting state of the NFA ($q_0$). Add $r_0$ to the list of states $R$. <br>
While $\exists$ an unmarked state $r \in R$: | Process every state $r$ in the list of states $R$.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mark $r$ | We are now processing $r$. Mark it as having been processed.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For each $\sigma \in \Sigma$ | For each symbol $\sigma$ in the alphabet:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $E = \text{move}(\delta, r, \sigma)$ | Call *move* on the currently-being-processed state $r$ and the current symbol $\sigma$. Name the result $E$.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $e = \varepsilon\text{-closure}(\delta, E)$ | Call *ε-clousre* on $E$. Name the result $e$.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If $e \notin R$ then let $R = R \cup \{e\}$ | Add $e$ to the set of states $R$. $R$ is a set, and should not have duplicates. Also, the empty list does not need to be added to $R$.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $\delta' = \delta' \cup \\{ r, \sigma, e \\} $ | Add the transition $(r, \sigma, e)$ to the DFA's set of transitions.
Let $F_d = \\{r \mid \exists s \in r \text{ with } s \in F_n \\}$ | Once you have processed every state in $R$, get the list of final states $F_d$ for the DFA. These are the set of states from $R$ which have a non-zero intersection with the final states of the input NFA.

So, $r_0$ becomes the starting state of the DFA, $R$ becomes the set of states of the DFA, $F_d$ becomes set of final states for the DFA, the transitions were buit during the loop, and the alphabet of the NFA and the DFA should be the same.

When doing this on paper, you can consider keeping track of all this info through the table method. Note, there are several table methods - this is just one example of how you might choose to organize your work.

 <img src="imgs/table_method_a.png" width="80%"/>

### Regex to NFA 
### We will skip this during the review session, since it was covered during the last review session; however, you should still be familiar with how to solve these types of problems!
![IMG_52724B54B9A9-1 (1)](./imgs/39cc426f-3928-48bc-b4b2-30cff10a61cc.png)
![IMG_29553EDBEF31-1 (1)](./imgs/5ab52f09-e7c7-4309-bf3b-5d23746ab998.png)
![IMG_9950FF5DEE1E-1 (1)](./imgs/0467aad3-26b3-4100-9d4f-c0ba89918b55.png)

### Common Oopsies on Quizzes
- Not indicating your start state
- Not indicate your end state(s)
- Your "DFA" is not actually a DFA (Is there at most one transition per character originating from each state? Are there no ε-transitions?)
- Not ε-closuring the start state
- Not moving and then ε-closuring afterward (the order is important!)
- Missing sanity checks: Does your DFA accept the same sample strings as the original NFA?

### NFA to DFA Conversion

1) (From Spring2024 Exam 1) 
<img width="290" alt="Screenshot 2025-04-07 at 6 53 28 PM" src="https://github.com/user-attachments/assets/dc8073be-a190-4d08-b86c-58900478014c" />
<details>
  <summary>Solution!</summary>
  <img width="1273" alt="Screenshot 2025-04-08 at 9 53 35 AM" src="https://github.com/user-attachments/assets/47e8c4d4-0dc4-495f-b399-77e8c6aceb1a" />
</details>

2) (From Fall2023 Exam 1) 
<img width="265" alt="Screenshot 2025-04-07 at 6 53 48 PM" src="https://github.com/user-attachments/assets/ebe6fb38-786d-4870-8c81-9a0ab5fddfab" />
<details>
  <summary>Solution!</summary>
  <img width="1045" alt="Screenshot 2025-04-08 at 9 51 12 AM" src="https://github.com/user-attachments/assets/6feac63a-d02e-4870-9344-e61623f059e2" />
</details>

3) (From Spring2019 Exam 2) 
<img width="655" alt="image" src="https://github.com/user-attachments/assets/a818dcd4-a682-4215-a04e-5af370c9e042" />
<details>
  <summary>Solution!</summary>
<img width="745" alt="Screenshot 2025-04-08 at 4 58 18 PM" src="https://github.com/user-attachments/assets/a97f73f9-fef9-403d-9697-cf8c54caf4fa" />
</details>

## Operational Semantics
### What is it?
- Give meaning to a programming language
  - Define how expressions evaluate to values
- Prove correctness of a program — does it behave as expected?

### Goals of OpSem
- Define how the language operates  
  - Specifies the rules for evaluation
    - how `+`, `if`, `let`, etc. work
    - whether `a = 7` means "check for equality" or "bind this value to this variable" 
  - Symbols are arbitrary - we can define what they mean (`4 ? 3 → 7` if we define `?` as addition)
- Prove correctness 
  - Ensures programs follow the defined evaluation rules

### Target vs. Meta Language
- **Target Language**: The language we're talking about - could be defined using a CFG like in Project 4
- **Meta Language**: The language we're using to describe the target language - working with its types and semantics when evaluating
  - Could be OCaml, English, etc.

### Building Evaluations with Rules
- **Axioms**: Basic truths (e.g., a number evaluates to itself)
- **Inference rules**: Combine sub-expressions to evaluate larger expressions
- Some syntax:
  - Value: $v$
  - Expression: $e$
  - Environment: $A$

### Examples!
- Example from Fall24Q3:
  <img width="917" alt="image" src="https://github.com/user-attachments/assets/cc9c8377-35cb-4eeb-8993-377a06a52649" />
  <details>
    <summary>Solution!</summary> 
    6 4 op4 3 op3
  </details>
- Example from Spring24E2:
  <img width="1247" alt="image" src="https://github.com/user-attachments/assets/7fd14472-8b35-4df3-a0a0-1559b9874d64" />
  <details>
    <summary>Solution!</summary> 
    (fun x -> op2 x false) false
  </details>
- Example from Spring2022Q4:
  <img width="917" alt="image" src="https://github.com/umd-cmsc330/review/blob/main/Exam2-Review/imgs/opsemex1.png?raw=true" />
  <details>
    <summary>Solution!</summary> 
    
    Blank #1: **let x = “cmsc”**
    
    Blank #2: **A, x:“cmsc”; “330” ⇒ “330”**

    Blank #3: **x ^ y**

    Blank #4: **A, x:“cmsc”, y:“330”(x) = “cmsc”**

    Blank #5: **A, x:“cmsc”, y:“330”(y) = “330”**

    Blank #6: **“cmsc330” is “cmsc” ^ “330”**
  </details>
- Example from Fall2023E2:
  <img width="930" alt="image" src="https://github.com/umd-cmsc330/review/blob/main/Exam2-Review/imgs/opsemex2.png?raw=true" />
  <details>
    <summary>Solution!</summary> 
    
    <img width="917" alt="image" src="https://github.com/umd-cmsc330/review/blob/main/Exam2-Review/imgs/opsemex2_soln.png?raw=true" />
  </details>

## Type Checking
- Type Systems
    - A series of rules that ascribe types to expressions
    - Ill vs Well-Typed Programs:
      - Well-Typed Programs: The type system accepts it.
      - Ill-Typed Programs: The type system rejects it.
    - Ill vs Well-Defined Programs:
      - Ill-Defined Programs: One where there is no semantic definition in the language.
      - Well-Defined Programs: One where all aspects of the program have a semantic definition. 
    - A mechanism for distinguishing good programs from bad
        - Good programs are well-typed
        - Examples
            - 0 + 1 -> well typed
            - false 0 -> ill-typed: can’t apply a Boolean
            - 1 + (if true then 0 else false) // ill-typed: can’t add boolean to integer
    - The same rules we used in operational semantics can be used to specify a program’s static semantics
        - `G ⊢ e : t`  → e has type t in context G
        - `G(x)` → look up x's type in G
        - `G,x:t`→ extend G so that x maps to t
- Rules
    - `G ⊢ true : bool` & `G ⊢ false : bool` & `G ⊢ n : Int`
    - `G ⊢e1: t1, G ⊢e2: t2, optype(op) = (t1,t2,t3)`
          ---
              `G ⊢ e1 op e2: t3`
    - `G ⊢ x : G(x)`
- Theory!
    -  "The point of a type system is to eliminate as many invalid programs while eliminating as few valid ones" -Simon Peyton Jones (co-creator of Haskell)
    - Soundness: "The most basic property of this type system or any other is safety (also called
soundness): well-typed terms do not 'go wrong' " - TAPL
      - Type safety means if a term type checks, its execution will be well-defined (never get stuck)
      - In simple terms: A sound type-checker will never accept an ill-typed program.
    - Completeness: All well-defined programs will pass the type-checker.
        - A complete type checker will accept all well-defined programs. The easiest complete type checker is one that accepts all programs (obviously not sound).
    - If a type checker is both sound and complete, then it rejects all bad programs and accepts all good programs, which cannot be achieved due to decidability.
    - Decidability
        - Type checking in a given type system is decidable if there exists a type checking algorithm that is sound, complete, and terminating.
        - Problem: Type checking in a Turing-complete language reduces to the halting problem. If you can embed a Turing machine using the types, type checking also reduces to the halting problem.
          - The halting problem is undecidable: There is no program that can check in an finite amount of time if all an arbitrary program given an arbitrary input will terminate or not.
    - Conclusion
        - No arbitrarily expressive type system can do all of the following:
          - always terminate
          - be sound
          - be complete
        - Example with OCaml's type system: `if true then 4 else ""` is well-defined (evaluates to 4) but ill-typed, so it fails the type checker
        - In practice, this limitation doesn't matter for realistic programs in everyday programming languages
- Examples!
  - [Slide deck with cute little animations!](https://docs.google.com/presentation/d/1Ix2U-fAPQ9Q4lK20-nbKVOLpYHJWBDqx4j3c6kBYQrY/edit?usp=sharing)


## CFGs
* Goal of CFGs
  * We want a way to define the construction of formal languages       
  * Regular expressions are limited: no "memory" that would give it the ability to assert relations b/w elements
* Non-terminal - can be a few different things (usually written as a capital letter)
* Terminal - a specific string a non-terminal could represent
* You can always convert a regex to a CFG but not always the other way around
* Examples of rules supported by CFGs but not regexes:
  * Palindromes/Balanced Parentheses
  * Relative numbering like a^nb^(2n)
* Modeled using parse trees
  * Left hand and right hand derivations can lead to different trees
* Ambiguous grammar - 2 valid left hand or right hand derivations
  * Checking if a grammar is ambiguous can be hard - there's no real "strategy" aside from trying to figure out a counterexample
  * Some tips of things to look for: duplicates (or repetition in general) and recursive rules
* Production rules grow downwards by convention
* Practice Problems:
  Given the following CFG, write a regex that matches it.\
  Is the CFG ambiguous? (If so, prove it!)\
  S → aS | bT\
  T → bT | b | ϵ
 <details>
    <summary>Solutions!</summary> 
    a*b+
    <br>
    Yes! An example string is bbb. Can either be S -> bT -> bbT -> bbb OR S -> bT -> bbT -> bbbT -> bbb
  </details>

## Interpreters

In-depth notes are available in the exam review folder or will be posted on Piazza
  * `lexparsintqs.txt` contains an overview of lexing, parsing, and interpreting with some sample multiple choice questions ("when will it fail?") and a walkthrough of how to build parse trees/abstract syntax trees
  * `samplegrammarblank.ml` contains a blank version of a lexer, parser, interpreter, and typechecker, *with step by step instructions on how to approach each one*
  * `samplegrammar.ml` contains a filled in version of a lexer, parser, interpreter, and typechecker, *without step by step instructions*, but *with inline comments*

### Stages

* **Lexing** - convert a string into a list of tokens. Does not check grammar, does not care about semantics.
  * Fails when a certain word/character is not part of the language
* **Parsing** - uses a list of tokens (via lexing) to create an AST based on CFG rules. Checks grammar, does not care about semantics, and assumes the input is already validly lexed.
  * The parser we have been using in class is LL(1) - lookahead by 1 token
  * Type of Recursive Descent Parser (top-down)
  * Only succeeds on grammatically correct expressions
* **Evaluating** - uses the (operational) semantics of a language to derive a value from an AST. Checks semantics, and assumes the input is already grammatically correct and lexed.
  * Fails when a value cannot be produced from an AST via the operational semantics of a language (as in it is not possible to construct a proof for said AST/expression)
<!-- finding the value of an expression using the tree generated by the parser based on Opsem rules.  -->
<!-- * Fails if an expression is meaningless in a language (ex: 1 + true via OCaml semantics) -->

  <details>
  <summary><b>funny image</b></summary> 
    
  ![Screenshot 2025-04-06 214712](https://i.imgur.com/qTwjJKE.png)
  </details>

* **Typechecking** - finding the type of an expression using the tree generated by the parser based on Typing rules. Assumes the input is already grammatically correct and lexed.
  * Fails when a type cannot be produced from an AST via the type rules of a language (same reason as eval, but different ruleset)

### Relationship between Parsing and Grammar

Let's say we have an example grammar:
```
E → M and E | M
M → N + M | N
N → 4 | 5 | true | (E)
```
Here's a portion of the parsing code that would parse this grammar:
```
type ast = Add of ast * ast | And of ast * ast | Int of int | Bool of bool

let rec parse_E input = (
  (*E → M and E | M*)
  let (toks_after_m, m_expr) = parse_M input in (*consume M*)
  match toks_after_m with
  |Tok_And::toks_after_and -> ( (*M and E case - consume Tok_And*)
    let (toks_after_e, e_expr) = parse_E toks_after_and in (*consume E*)
    (toks_after_e, And(m_expr, e_expr)) (*return result based on common sense*)
  )
  |_ -> (toks_after_m, m_expr) (*M case - nothing to consume*)
)
```
Now imagine we modify this grammar slightly:
```
E → and M E | M
M → + N M | N
N → 4 | 5 | true | (E)
```
How will our `parse_E` function be affected?

<details>
  <summary>Answer</summary>

  ```
  let rec parse_E input = (
    (*E → and M E | M*)
    match input with
    |Tok_And::toks_after_and -> ( (*M and E case - consume Tok_And*)
      let (toks_after_m, m_expr) = parse_M toks_after_and in (*consume M*)
      let (toks_after_e, e_expr) = parse_E toks_after_m in (*consume E*)
      (toks_after_e, And(m_expr, e_expr)) (*return result based on common sense*)
    )
    |_ ->  parse_M input (*M case - consume M*)
  )
  ```
</details>

### Multiple choice examples

Very similar to the quiz questions, determine what stage a program fails at, if any

#### Classic case!
  
```
E → M && E | M or E | M
M → N + M | N − M | N
N → 1 | 2 | 3 | 4 | true | false | (E)
```

1.a: `1 + 2 - (true && false)`

1.b: `true + {3 - 2}`

1.c: `1 * 3`

1.d: `22`

<details>
  <summary>Answers</summary>
          
1.a: eval
          
1.b: lex

1.c: lex

1.d: parse

</details>

<!-- ngl this stuff is so trivial idt we need 3 sections of it -->

<!-- * It could have unexpected rules!

```
E → M && G | M or G | M
M → N + M | N − M | N
N → 1 | 2 | 3 | 4
G → true | false
```

2.a: `true && false`

2.b: `true && true && false`

2.c: `1 + 2`

2.d: `1 + false`

2.e: `(true)`

<details>
  <summary>Answers</summary>
          
2.a: parse
          
2.b: parse

2.c: succeeds

2.d: parse

2.e: lex

</details> -->

#### It could have odd syntax!

```
E → + E E | ∗ E E | sq E | ex p E E | && E E | or E E | N
N → 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | true | false
```

3.a: `- + 1 2 3`

3.b: `true && false or true`

3.c: `&& true or false false`

3.d: `* 2 && true false`

<details>
  <summary>Answers</summary>
          
3.a: lex
          
3.b: parse

3.c: succeeds

3.d: eval

</details>

### Debugging (requested by piazza)

[Spring 2024 (slightly modified)](./debugging.md)\
[Solutions](./debugging_solns.md)
