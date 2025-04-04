# Discussion 9 - Friday, April 4th

## Reminders

1. **Exam 2** is on **April 10th** in your assigned lecture.
2. Project 5 is released, due **April 17th @ 11:59PM**.

## Type Checking

$\Huge \frac{}{G\ \vdash\ \text{x}\ :\ G(\text{x})} \quad \frac{}{G\ \vdash\ \text{true}\ :\ \text{bool}} \quad \frac{}{G\ \vdash\ \text{false}\ :\ \text{bool}} \quad \frac{}{G\ \vdash\ \text{n}\ :\ \text{int}} \quad$

$\Huge \frac{G\ \vdash\ e1\ :\ \text{t1} \quad G,\ x\ :\ \text{t1}\ \vdash\ e2\ :\ \text{t2}}{G\ \vdash\ \text{let}\ x\ =\ e1\ \text{in}\ e2\ :\ t2} \quad
\frac{G\ \vdash\ e1\ :\ \text{bool} \quad G\ \vdash\ e2\ :\ \text{bool}}{G\ \vdash\ e1\ \text{and}\ e2\ :\ \text{bool}} \quad$

$\Huge \frac{G\ \vdash\ e\ :\ \text{int}}{G\ \vdash\ \text{eq0}\ e\ :\ \text{bool}} \quad
\frac{G\ \vdash\ e1\ :\ \text{bool} \quad G\ \vdash\ e2\ :\ \text{t}\quad G\ \vdash\ e3\ :\ \text{t}}{G\ \vdash\ \text{if}\ e1\ \text{then}\ e2\ \text{else}\ e3\ :\ \text{t}} \quad$

Using the rules given above, show that the following statements are **well typed**:
1. `eq0 if true then 0 else 1`
2. `let x = 5 in eq0 x and false`

<details>
  <summary>Solutions!</summary>

1. ![image](https://hackmd.io/_uploads/BJDX-6B61g.png)

2. ![image](https://hackmd.io/_uploads/SyGEZTSa1l.png)

</details>

## Type Inference
There is 2 parts of type inference that we care about: 
 - constraint construction
 - constraint solving
 
### Constraint construction problems
<!--- data values--->
$\Huge 
\frac{}{G\ \vdash\ \text{true}\ :\ bool\ \dashv\ \{\}} 
\quad
\frac{}{G\ \vdash\ \text{false}\ :\ bool\ \dashv\ \{\}} 
\quad
\frac{}{G\ \vdash\ n\ :\ int\ \dashv\ \{\}}$

<!--- plus --->
$\Huge \frac{G\ \vdash\ e_1\ :\ t_1\ \dashv\ C_1\quad G\ \vdash\ e_2\ :\ t_2\ \dashv\ C_2}{G\ \vdash e_1\ +\ e_2\ :\ int\ \dashv\ \{t_1:t_2,\ t_1: int\}\ \cup\ C_1\ \cup\ C_2}$

<!--- and --->
$\Huge \frac{G\ \vdash\ e_1\ :\ t_1\ \dashv\ C_1\quad G\ \vdash\ e_2\ :\ t_2\ \dashv\ C_2}{G\ \vdash e_1\ \\&\\& \ e_2\ :\ bool\ \dashv\ \{t_1:t_2,\ t_1: bool\}\ \cup\ C_1\ \cup\ C_2}$

<!-- eq0 -->
$\Huge \frac{G\ \vdash\ e\ :\ t_1\ \dashv\ C}{G\ \vdash\ \text{eq0}\ e\ :\ bool\ \dashv\ \{t_1:int\}\ \cup\ C}$

<!-- if --> 
$\Huge \frac{G\ \vdash\ e_1\ :\ t_1\ \dashv\ C_1 \quad G\ \vdash\ e_2\ :\ t_2\ \dashv\ C_2 \quad G\ \vdash\ e_3\ :\ t_3\ \dashv\ C_3}{G\ \vdash\ \text{if}\ e_1\ \text{then}\ e_2\ \text{else}\ e_3\ :\ t_2\ \dashv\ \{t_1:bool,\ t_2:t_3\}\ \cup\ C1\ \cup\ C_2\ \cup\ C_3}$

Use the above rules to show the type inference proof for the following:
1. `true && eq0 5`
2. `true + 4`
3. `if true then 1 + 2 else 5`
4. `if true && false then 1 + 2 else eq0 0`

<details>
  <summary>Solutions!</summary>
    
1. $\cfrac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \{\}}
                \quad \cfrac{\cfrac{}{G\ \vdash\ 5\ :\ int\ \dashv \{\}}}{G\ \vdash\ \text{eq0}\ 5\ : bool\ \dashv \{int:int\}}}{G\ \dashv\ true\ \\&\\&\ \text{eq0}\ 5\ :\ bool \dashv\ \{bool:bool,\ bool:bool,\ int:int\}}$
    - proof: $\cfrac{\cfrac{}{G\ \vdash\ true\ :\ t_1\ \dashv\ \{\}}
                \quad \cfrac{\cfrac{}{G\ \vdash\ 5\ :\ t_3\ \dashv \{\}}}{G\ \vdash\ \text{eq0}\ 5\ : t_2\ \dashv \{t_3:int\}}}{G\ \dashv\ true\ \\&\\&\ \text{eq0}\ 5\ :\ bool \dashv\ \{t_1:bool,\ t_2:bool,\ t_3:int\}}$
    where
    - $t_1 = bool$
    - $t_2 = bool$
    - $t_3 = int$
2. INVALID - $\cfrac{\cfrac{}{G\ \vdash\ true\ :\ bool \dashv \{\}}\quad \cfrac{}{G\ \vdash\ 4\ :\ int \dashv\ \{\}} }{G\ \vdash true\ + 4\ :\ bool \dashv \{bool:int\}}$
    - proof: $\cfrac{\cfrac{}{G\ \vdash\ true\ :\ t_1 \dashv \{\}}\quad \cfrac{}{G\ \vdash\ 4\ :\ t_2 \dashv\ \{\}} }{G\ \vdash true\ + 4\ :\ bool \dashv \{t_1:t_2,t_1:int\}}$
    where
    - $t_1 = bool$
    - $t_2 = int$
    - $\{bool:int,bool:int\}$ is a contradiction, hence invalid
3. $\cfrac{\cfrac{}{G\ \  \vdash\ true\ : bool\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ \  \vdash\ 1\ : int\ \dashv\ \{\}}\quad \cfrac{}{G\ \  \vdash\ 2\ : int\ \dashv\ \{\}}}{G\ \  \vdash\ 1\ +\ 2\ :\ int\dashv\ \{int:int\}}\quad\cfrac{}{G\ \  \vdash\ 5\ : int\ \dashv\ \{\}}}{G\ \  \vdash\ \text{if}\ true\ \text{then}\ 1\ +\ 2\ \text{else}\ 5\ :\ int\dashv\ \{int:int,\ bool:bool\}}$
    - proof: $\cfrac{\cfrac{}{G\ \  \vdash\ true\ : t_1\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ \  \vdash\ 1\ : t_4\ \dashv\ \{\}}\quad \cfrac{}{G\ \  \vdash\ 2\ : t_5\ \dashv\ \{\}}}{G\ \  \vdash\ 1\ +\ 2\ :\ t_2\dashv\ \{t_4:t_5,t_4:int\}}\quad\cfrac{}{G\ \  \vdash\ 5\ : t_3\ \dashv\ \{\}}}{G\ \  \vdash\ \text{if}\ true\ \text{then}\ 1\ +\ 2\ \text{else}\ 5\ :\ int\dashv\ \{t1:bool,t_2:t_3,t_4:t_5,t_4:int\}}$
    where
    - $t_1 = bool$
    - $t_2 = int$
    - $t_3 = int$
    - $t_4 = int$
    - $t_5 = int$
4. INVALID - $\tiny \cfrac{\cfrac{\cfrac{}{G\ \  \vdash\ true\ : bool\ \dashv\ \{\}}\quad \cfrac{}{G\ \  \vdash\ false\ : bool\ \dashv\ \{\}}}{G\ \  \vdash\ true\ \\&\\&\ false\ :\ bool\dashv\ \{bool:bool\}}\quad \cfrac{\cfrac{}{G\ \  \vdash\ 1\ : int\ \dashv\ \{\}}\quad \cfrac{}{G\ \  \vdash\ 2\ : int\ \dashv\ \{\}}}{G\ \  \vdash\ 1\ +\ 2\ :\ int\dashv\ \{int:int\}}\quad\cfrac{\cfrac{}{G\ \  \vdash\ 0\ : int\ \dashv\ \{\}}}{G\ \  \vdash\ eq0\ 0\ :\ bool\dashv\ \{int:int\}}}{G\ \  \vdash\ \text{if}\ true\ \\&\\&\ false\ \text{then}\ 1\ +\ 2\ \text{else}\ eq0\ 0\ :\ int\dashv\ \{bool:bool,\ int:int,\ int:bool\}}$
    - proof: $\tiny \cfrac{\cfrac{\cfrac{}{G\ \  \vdash\ true\ : t_4\ \dashv\ \{\}}\quad \cfrac{}{G\ \  \vdash\ false\ : t_5\ \dashv\ \{\}}}{G\ \  \vdash\ true\ \\&\\&\ false\ :\ t_1\dashv\ \{t_4:t_5,t_4:bool\}}\quad \cfrac{\cfrac{}{G\ \  \vdash\ 1\ : t_6\ \dashv\ \{\}}\quad \cfrac{}{G\ \  \vdash\ 2\ : t_7\ \dashv\ \{\}}}{G\ \  \vdash\ 1\ +\ 2\ :\ t_2\dashv\ \{t_6:t_7,t_6:int\}}\quad\cfrac{\cfrac{}{G\ \  \vdash\ 0\ : t_8\ \dashv\ \{\}}}{G\ \  \vdash\ eq0\ 0\ :\ t_3\dashv\ \{t_8:int\}}}{G\ \  \vdash\ \text{if}\ true\ \\&\\&\ false\ \text{then}\ 1\ +\ 2\ \text{else}\ eq0\ 0\ :\ int\dashv\ \{t_1:bool,\ t_2:t_3,\ t_4:t_5,t_4:bool,t_6:t_7,t_6:int,t_8:int\}}$
    where
    - $t_1 = bool$
    - $t_2 = int$
    - $t_3 = bool$
    - $t_4 = bool$
    - $t_5 = bool$
    - $t_6 = int$
    - $t_7 = int$
    - $t_8 = int$
    - $t_2= int \land t_3 = bool \land t_2:t_3 \Rightarrow bool:int$ which is a contradiction
</details>

Now let's add variables and an unknown type:
$\huge \frac{}{G\ \vdash\ read\ ()\ :\ t\ \dashv\ \{\}}$ (read returns some unknown type)

$\huge \frac{}{G\ \vdash\ x\ :\ G(x)}
\quad
\frac{G\ \vdash\ e_1\ : t_1\ \dashv\ C_1
      \quad
      G,x:t_1\ \vdash\ e_2\ : t_2\ \dashv\ C_2}
      {G\ \vdash\ \text{let}\ x\ =\ e_1\ \text{in}\ e_2\ :\ t_2\ \dashv\ C_1\ \cup\ C_2}$
Note: this does not support shadowing of variables (behaviour is more like binding a mutable variable)

1. `let x = read () in x + 1`
2. `let x = read () in let y = read () in x && y`
3. `let x = read () in if x then x else eq0 x`
<details>
  <summary>Solutions!</summary>
    
1. $\cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ t\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ x:t\vdash\ x\ :\ G\ ,\ x:t(x)\ \dashv\ \{\}}\quad \cfrac{}{G\ ,\ x:t\vdash\ 1\ : int\ \dashv\ \{\}}}{G\ ,\ x:t_0\vdash\ x\ +\ 1\ :\ int\dashv\ \{t:int,\ int:int\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ x\ +\ 1\ :\ int\dashv\ \{t:int,\ int:int\}}$
    - proof: $\cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ t_1\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ x:t_1\vdash\ x\ :\ G\ ,\ x:t_1(x)\ \dashv\ \{\}}\quad \cfrac{}{G\ ,\ x:t_1\vdash\ 1\ : t_3\ \dashv\ \{\}}}{G\ ,\ x:t_1\vdash\ x\ +\ 1\ :\ t_2\dashv\ \{t_1:int,\ t_3:int\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ x\ +\ 1\ :\ t_2\dashv\ \{t_1:int,\ t_3:int\}}$
    where
    - $t_1 = \text{Unknown Type ('a)}$
    - $t_2 = int$
    - $t_3 = int$
    - notice our constraints let us show that 'a = int! 
2. $\tiny \cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ t_1\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ x:t_1\vdash\ read\ ()\ :\ t_2\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ y:t_2\vdash\ x\ :\ G\ ,\ y:t_2(x)\ \dashv\ \{\}}\quad \cfrac{}{G\ ,\ y:t_2\vdash\ y\ :\ G\ ,\ y:t_2(y)\ \dashv\ \{\}}}{G\ ,\ y:t_2\vdash\ x\ \\&\\&\ y\ :\ bool\dashv\ \{t_1:bool,\ t_2:bool\}}}{G\ ,\ x:t_1\vdash\ \text{let}\ y\ =\ read ()\ \text{in}\ x\ \\&\\&\ y\ :\ bool\dashv\ \{t_1:bool,\ t_2:bool\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ \text{let}\ y\ =\ read ()\ \text{in}\ x\ \\&\\&\ y\ :\ bool\dashv\ \{t_1:bool,\ t_2:bool\}}$
    - proof $\tiny \cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ t_1\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ x:t_1\vdash\ read\ ()\ :\ t_2\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ y:t_2\vdash\ x\ :\ G\ ,\ y:t_2(x)\ \dashv\ \{\}}\quad \cfrac{}{G\ ,\ y:t_2\vdash\ y\ :\ G\ ,\ y:t_2(y)\ \dashv\ \{\}}}{G\ ,\ y:t_2\vdash\ x\ \\&\\&\ y\ :\ t_3\dashv\ \{t_1:bool,\ t_2:bool\}}}{G\ ,\ x:t_1\vdash\ \text{let}\ y\ =\ read ()\ \text{in}\ x\ \\&\\&\ y\ :\ t_3\dashv\ \{t_1:bool,\ t_2:bool\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ \text{let}\ y\ =\ read ()\ \text{in}\ x\ \\&\\&\ y\ :\ t_3\dashv\ \{t_1:bool,\ t_2:bool\}}$
    where
    - $t_1 = \text{Unknown Type ('a)}$
    - $t_2 = \text{Unknown Type ('b)}$
    - $t_3 = bool$
    - notice our constraints let us show that 'a = bool, and 'b = bool'! 
3. INVALID - $\tiny \cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ t\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ x:t\vdash\ x\ :\ G\ ,\ x:t(x)\ \dashv\ \{\}}\quad \cfrac{}{G\ ,\ x:t\vdash\ x\ :\ G\ ,\ x:t(x)\ \dashv\ \{\}}\quad\cfrac{\cfrac{}{G\ ,\ x:t\vdash\ x\ :\ G\ ,\ x:t(x)\ \dashv\ \{\}}}{G\ ,\ x:t\vdash\ eq0\ x\ :\ bool\dashv\ \{t:int\}}}{G\ ,\ x:t\vdash\ \text{if}\ x\ \text{then}\ x\ \text{else}\ eq0\ x\ :\ t\dashv\ \{t:int,\ t:bool\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ \text{if}\ x\ \text{then}\ x\ \text{else}\ eq0\ x\ :\ t\dashv\ \{t:int,\ t:bool\}}$
    - proof: $\tiny \cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ t_1\ \dashv\ \{\}}\quad \cfrac{\cfrac{}{G\ ,\ x:t_1\vdash\ x\ :\ G\ ,\ x:t_1(x)\ \dashv\ \{\}}\quad \cfrac{}{G\ ,\ x:t_1\vdash\ x\ :\ G\ ,\ x:t_1(x)\ \dashv\ \{\}}\quad\cfrac{\cfrac{}{G\ ,\ x:t_1\vdash\ x\ :\ G\ ,\ x:t_1(x)\ \dashv\ \{\}}}{G\ ,\ x:t_1\vdash\ eq0\ x\ :\ t_2\dashv\ \{t_1:int\}}}{G\ ,\ x:t\vdash\ \text{if}\ x\ \text{then}\ x\ \text{else}\ eq0\ x\ :\ t_1\dashv\ \{t_1:bool,t_1:t_2,t_1:int\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ \text{if}\ x\ \text{then}\ x\ \text{else}\ eq0\ x\ :\ t_1\dashv\ \{t_1:bool,t_1:t_2,t_1:int\}}$
    where
    - $t_1 = \text{Unknown Type ('a))}$
    - $t_2 = bool$
    Notice our constraints show a contradiction: $t_1:bool \land t_1:int \Rightarrow bool:int$
</details>

### Constraint Solving
Indicate if each of the following constraint sets contain any contradictions. (Maybe show unification steps if needed. idk.)
1. {Int:Int}
2. {Bool:Int}
3. {Int:Int, Bool:Bool, Int:Int}
4. {Bool:Bool, Int:Bool}
5. {'a:Int}
6. {'a:Bool, 'a:'a}
7. {'a:'b, 'a:bool, 'b:bool}
8. {'a:'b, 'a:bool, 'b:'c}
9. {'a:'b, 'b:'c, 'a:'d}
10. {'a:'b, 'a: int, 'b:int', 'c:'b, 'c:bool}
11. {'a:'b, 'b:int, 'a:'c, 'c:'a, 'c:'d, 'd:bool, 'c:int}


#### Unification steps

Go through the contraints, and take a contraint pair $c$ and do the following
- if $c$ is $x:x$ (like int:int, or 'a:'a), remove from constraints
- if $c$ is $x:type$ or $type:x$ (like 'a:int or int:'a), remove from constraints and edit all the other constraints in the set by replacing x with type
- if $c$ is $type_1:type_2$ (like int:bool), then stop and say contradiction, inference fails

Do the above until the set is empty or error occurs

<details>
  <summary>Solutions!</summary>

1. No contradictions
2. Yes, Bool $\ne$ Int
3. No contradictions
4. Yes, Bool $\ne$ Int
5. No contradictions
6. No contradictions
7. No contradictions
8. No contradictions
9. No contradictions
10. Yes, $'a = int = 'b = 'c = bool \Rightarrow Bool = Int$ 
11. Yes

</details>


## Subtyping

#### Definition:

If `S` is a subtype of `T`, written S <: T,then an `S` can be used anywhere a `T` is expected.

`int` <: `int`
`int` is not a subtype of `bool`

In the context of subtyping records, we can take a more liberal view of record types, seeing a record as "the set of all records with *at least* a field [name] of type [type]". This means that the "smaller" subtype is actually the one with more fields in the record.

`{x:int, y:int, z:bool}` <: `{x:int, y:int}`
`{y:int}` <: `{}`
`{x:int}` is not a subtype of `{y:int}`

Also, the types within the records can contain subtypes. A record `A` is a subtype of record `B` if all of the variables within `A` are subtypes of equivalently named variables in `B`.

`{x:{a:int, b:int}, y:{m:int}}` <: `{x:{a:int}, y}`

#### Properties of subtyping:

- Reflexivity: for any type `A`, `A` <: `A`
- Transitivity: if `A` <: `B` <: `C`, then `A` <: `C`
- Permutation: components of a record are not ordered
    - `{x:a, y:b}` <: `{x:b, y:a}`
    - `{x:b, y:a}` <: `{x:a, y:b}`

For more information about subtyping, take a look at the subtyping information from this [past 330 type checking project](https://github.com/cmsc330spring24/cmsc330spring24/blob/main/projects/project5.md).

## A different type of opsem problem

Another one like this is available on [Exam 2 Spring 2024](https://bakalian.cs.umd.edu/assets/past_assignments/spring24e2sols.pdf), the one below is taken from [Exam 2 Fall 2024](https://bakalian.cs.umd.edu/assets/past_assignments/fall24e2solns.pdf).

You are given two sets of rules for two different langauges.

<!--- values --->
These rules are valid for both languages:

$\cfrac{}{\text{true} \rightarrow \text{true}}\quad \cfrac{}{\text{false} \rightarrow \text{false}}\quad \cfrac{A(x) = v}{A; x \rightarrow v}$

These two rules are valid *only for language **1***:

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; e_1\ e_2 \ \text{op1} \rightarrow v_3}$

$\cfrac{A;e_1 \rightarrow v_1 \qquad A,x:v_1; e_2 \rightarrow v_2}{A;\text{let }x = e_1\ \text{in}\ e_2 \rightarrow v_2}$

These two rules are valid *only for language **2***:

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; \text{op2} \ e_2\ e_1 \rightarrow v_3}$

$\cfrac{A;e_2 \rightarrow v_1 \qquad A,x:v_1; e_1 \rightarrow v_2}{A;(\text{fun } x \rightarrow e_1)\ e_2 \rightarrow v_2}$

Convert the following Language 1 sentence to its language 2 counterpart

    A; let x = true in (true x op1)

______

How do we approach this sort of problem? 

First, figure out what the sentence *means* - what is it actually doing?

In this case, Language 1 says that $A;\ let\ x\ =\ true\ in\ true\ x\ \text{op1}$ tells us to use this rule first, with $x\ =\ x$, $e1\ = true$, and $e2\ =\ true\ x\ \text{op1}$:

$\cfrac{A;e_1 \rightarrow v_1 \qquad A,x:v_1; e_2 \rightarrow v_2}{A;\text{let }x = e_1\ \text{in}\ e_2 \rightarrow v_2}$

Recall that the bottom half of this is just a representation of what the sentence looks like in the language. The top half is what the language *means*.

Which rule in lanugage 2 has the same *meaning* as that one? This one looks very similar...

$\cfrac{A;e_2 \rightarrow v_1 \qquad A,x:v_1; e_1 \rightarrow v_2}{A;(\text{fun } x \rightarrow e_1)\ e_2 \rightarrow v_2}$

<details>
  <summary>So, can we just plug in e1 for e1 and e2 for e2?</summary>

NO! The meaning is different! 
    
The first rule evaluates **e1** to a value, then updates the environment with that, and evaluates **e2**.
    
The second rule evaluates **e2** to a value, then updates the environment with that, and evaluetes **e1**.

</details>

\
Given that, we can convert like this:

$A;\ let\ x\ =\ true\ in\ true\ x\ \text{op1}$

to

$A;\ (\text{fun } x \rightarrow true\ x\ \text{op1})\ true \rightarrow v_2$

Okay, now we're closer, but $true\ x\ \text{op1}$ is still a Language 1 construct, so we need convert that part as well.

What does $true\ x\ \text{op1}$ mean in Language 1?

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; e_1\ e_2 \ \text{op1} \rightarrow v_3}$

With $e1\ = true$, $e2 = x$. 
What's the matching Language 2 rule?

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; \text{op2} \ e_2\ e_1 \rightarrow v_3}$

<details>
  <summary>Here, can we just plug in e1 for e1 and e2 for e2?</summary>

Yes! Here the meaning is the same, unlike before.
    
The first rule evaluates **e1** to a value v1, then evaluates **e2** to a value v2, then gets the value v3 from the metalanguage "if v1 then not v2 else v2".
    
The second rule evaluates **e1** to a value v1, then evaluates **e2** to a value v2, then gets the value v3 from the metalanguage "if v1 then not v2 else v2".
    
They are the same.

</details>
\

So Language 1's  $true\ x\ \text{op1}$ becomes Language 2's $\text{op2}\ x\ true$

Let's put it all together!
    
<details>
  <summary>Solution!</summary>

    A; (fun x -> op2 x true) true

</details>



## Additional Readings & Resources

- [Professor Mamat's Type Checking Slides](https://bakalian.cs.umd.edu/assets/slides/19-Typechecking.pdf)
- [Cliff's Type Checking and Type Inference Notes](https://bakalian.cs.umd.edu/assets/notes/typing.pdf)
- [Type Checker Problem Generator](https://bakalian.cs.umd.edu/330/practice/typechecker)
- [Subtyping Reference from TAPL](https://www.cs.umd.edu/class/spring2024/cmsc330-030X-040X/assets/slides/TAPL_Ch._15.pdf)
