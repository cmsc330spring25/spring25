# Discussion 10 - Friday, April 11th

## Reminders

- Project 5 due **April 17th, 2024, 11:59PM**

## Lambda Calculus Review
*Refer to [Cliff's Lambda Calculus Notes](https://bakalian.cs.umd.edu/assets/notes/lambdacalc.pdf) for a complete resource.*

### Bound vs. Free Variables
- A bound variable is one who’s value is dependent on a parameter of
a lambda function.
- A free variable is a variable that is not a bound variable: its value is **independent** of lambda function parameters.
```scheme
(λx. x a ) b
     ↑ x is a bound variable
     
(λx. x a ) b
       ↑ a is a free variable
       
(λx. x a ) b
           ↑ b is a free variable
```

### Explicit Rules to remove ambiguity
- Expressions $e$ are left associative
```
a b c means (a b) c
```
- The scope of a function goes until the **end of the entire expression** or until a (unmatched) parenthesis is reached
```
λx .λy. a b means λx. (λy. (a b))
```

### Alpha Conversion
- An alpha-conversion ($\alpha$-conversion) is the process of renaming all the variables that are bound together along with the bounded parameter to a different name to increase readability.
```scheme
(λx. (λx. (λy. x y)) x) x → 
(λa. (λb. (λy. b y)) a) x            Alpha Conversion
```

### Beta Reduction
- The process of of applying a function is called reducing. We call a function call a beta reduction ($\beta$-reduction).
```scheme
(λx. λy. y x) a b →
((λx. λy. y x) a) b →          Left associativity
(λy. y a) b →                  Beta reduce the x function
b a                            Beta reduce the y function
```
- When you cannot reduce any further, we say the expression is in beta normal form.

### Eager vs. Lazy Evaluation
- Eager Evaluation (Call by Value): Before doing a beta reduction, we make sure the argument cannot, itself, be further evaluated:

```scheme
(λz. z) ((λy. y) x) →          
(λz. z) x →                    We evaluate the argument first!
x
```

- Lazy Evaluation (Call by Name): We can specifically choose to perform beta-reduction _before_ we evaluate the argument:

```scheme
(λz. z) ((λy. y) x) →
(λy. y) x →                    We apply the function (beta-reduce) first!
x
```

## Exercises

**Make the parentheses explicit in the following expressions:**

1. `a b c`

2. `λa. λb. c b`

3. `λa. a b λa. a b`

<details>
  <summary>Solutions!</summary>

1. `((a b) c)`

2. `(λa. (λb. (c b)))`

3. `(λa. ((a b) (λa. (a b))))`
    
</details>

**Identify the free variables in the following expressions:**

4. `λa. a b a`

5. `a (λa. a) a`

6. `λa. (λb. a b) a b`

<details>
  <summary>Solutions!</summary>

4. λa. a **b** a

5. **a** (λa. a) **a**

6. λa. (λb. a b) a **b**
    
</details>

**Apply alpha-conversions to the following:**

7. `λa. λa. a`

8. `(λa. a) a b`

9. `(λa. (λa. (λa. a) a) a)`

<details>
  <summary>Solutions!</summary>

7. `λa. λx. x`

8. `(λx. x) a b`

9. `(λx. (λy. (λz. z) y) x)`
    
</details>

**Apply beta-reductions to the following:**

10. `(λa. a b) x b`

11. `(λa. b) (λa. λb. λc. a b c)`

12. `(λa. a a) (λa. a a)`

<details>
  <summary>Solutions!</summary>

10. `(x b) b`

11. `b`

12. `(λa. a a) (λa. a a) → (λa. a a) (λa. a a) → (λa. a a) (λa. a a) → ... infinite recursion`
    
</details>

**Consider the following subset of the church encodings:**

$$
\begin{align*}
\text{true} &\equiv \lambda x.\lambda y.x\\
\text{false} &\equiv \lambda x.\lambda y.y\\
\text{if a then b else c} &\equiv a\ b\ c
\end{align*}
$$

Convert the following sentences to their equivalent lambda calc encodings:

13. `if true then false else true`
14. `if false then if false then false else true else false`

Next, reduce the lambda calc expressions to their simplest form. Verify that the resulting expression is equivalent to the english sentence when evaluated.

<details>
  <summary>Solutions!</summary>

13.
    ```
    (λx. λy. x) (λx. λy. y) (λx. λy. x)
    (λy. (λx. λy. y)) (λx. λy. x)
    (λx. λy. y)
    false
    ```
14.
    ```
    (λx. λy. y) ((λx. λy. y) (λx. λy. y) (λx. λy. x)) (λx. λy. y)
    (λx. λy. y) ((λy. y) (λx. λy. x)) (λx. λy. y)
    (λx. λy. y) (λx. λy. x) (λx. λy. y)
    (λy. y)  (λx. λy. y)
    (λx. λy. y)
    false
    ```
</details>

## Additional Readings & Resources
- [Cliff's Lambda Calculus Notes](https://bakalian.cs.umd.edu/assets/notes/lambdacalc.pdf)
- [Spring 2021 - Lambda Calculus Basics](https://www.cs.umd.edu/class/spring2021/cmsc330/lectures/24-lambda-calc-1.pdf)
- [Fall 2022 - Discussion 10 (Lambda Calculus)](https://github.com/umd-cmsc330/fall2022/tree/main/discussions/discussion10#lambda-calculus)
- [Types and Programming Languages (Pierce 2002)](https://www.cs.sjtu.edu.cn/~kzhu/cs383/Pierce_Types_Programming_Languages.pdf)
  - See Chapter 5: _The Untyped Lambda-Calculus_
- [nmittu.github.io - Beta Reduction Practice](https://nmittu.github.io/330-problem-generator/beta_reduction.html)
