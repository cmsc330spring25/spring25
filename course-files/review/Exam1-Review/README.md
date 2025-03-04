# Review
## PL Concepts and OCaml Basics (15 mins)
Notes: [PLConceptsOCamlBasicsReview1.pdf](https://github.com/user-attachments/files/17236379/PLConceptsOCamlBasicsReview1.pdf)
* Syntax: what a program looks like
* Semantics: what a program means (what it computes)
  * Same syntax could have different meanings for different languages
  * Python: `x = 5` declares x as having the value of 5, while in OCaml checks for equality. 
  * Formal semantics–mathematical definition, such as operational semantics
* Paradigm
  * Different semantics amongst different programming languages
  * Fundamental differences
    * Recursion vs Looping
    * Mutation (Imperative) vs Functional Update of variables
    * Manual vs Automatic Memory Management (Garbage Collection)
  * Scripting/Dynamic
    * Higher-layer abstractions
  * Implementation
    * Compilation vs Interpretation
      * Compiler: source program translated to another language, often machine code, then executed (gcc, javac)
      * Interpreter: executes source program as is (more on this later in the semester)
  * Functional vs Imperative
    * Functional
      * Higher level of abstraction

#### OCaml Specific
  * Ocaml is a compiled and bootstrapped language
  * Implicitly typed --> the compiler infers the type of your variables and values at compile time
  * Vs. Explicitly typed --> Same as Java, C etc... declaration of variables is paired with a declaration of their type
  * Statically typed --> once the type of a variable is inferred, the variable must abide by the type throughout its scope (type enforcement). AKA variables are unable to change their type (unlike languages such as Javascript and Python)
  * Primitive built-in data types
     * int, float, char, string, bool, and unit
     * Composite data types include tuples, lists, option, and variants
  * Arithmetic operators in OCaml are not overloaded --> you can use +, -, *, / on two ints but not on floats
  * tuples - heterogeneous, can have different types, can vary in length
  * lists - homogeneous, can only have same times, can vary in length
   * `::` vs `@` -> `element :: [list of the type of the element]` vs `['a] @ ['a]`
   * There are also no statements in OCaml, everything is an expression, all expressions have values (expressions get evaluated to values), and all values have types. Even functions are expressions and those have their own types!!
  * Records vs Variants
   * Records and variants are both user defined types
    * Records generally used when for description
    * Variants generally used for polymorphism
#### More PL Concepts
 * Currying - transformation of a function that takes in multiple arguments a sequence of single argument functions -> `let f a b = a + b in let g = f 5 in g 5;;` evaluates to 10
 * Other currying example: (fun x -> fun y -> x + y) is the same as (fun x y -> x + y)
 * Shadowing - a variable within a scope has the same name as a variable in the outer scope, outer variable gets shadowed by inner variable (ex. let x = 5 in let x = 4 in x evaluates to 4)
 * Side effects - any observable effect besides returning a result (printing, file input, exceptions).
 * OCaml/functional languages help reduce side effects through favoring immutability

## OCaml Data and Typing (20 mins)
#### Typing
* Type System - How data is treated and what you can do with certain pieces of data. 
* Type Checking - The process of determining what a piece of data’s type is.
* Type Inference -  How the language will infer the types of the data

#### Expressions & Values
* In OCaml, almost everything is an expression.
* Expressions evaluate to values.
* All values are expressions, but not all expressions are values.
* All expressions also have a (data) type

Variables types are determined by the operations or syntax of the expression. <br>
Examples:
* Bool -> `&&, ||, not`
* Int -> `+, -, *, mod, /,...`
* Float -> `+., -., *., mod., /.,...`
* String -> `^`

And many more! <br>
Some operators work on many different types.  
* `<=`  The output will always be of type bool.   
#### Generics
* `'a` is a generic type can be anything, it's type is unknown. 
* When the type cannot be determined by inferencing a generic type is used. 
* Multiple types in an expression can be generic. 
    ```
    ('a -> 'b) -> 'a -> 'b -> bool
    fun f x y -> (f x) = y
    ```
### Pattern Matching Types
* Pattern matching allows for inputs to be broken down and matched based on their type.
* Pattern matching can happen in a `match` statement or by using a `let` statement.
* Matching can allow for easier manipulation of data
    ```
    let pat_mat lst =
    match lst with
    |[] -> ([],0)
    |h::t -> (t, h+1)

    let x = pat_mat [1;2;3]
    let (l,v) = x
    ```
  In this example, we pattern match the list input with a `match` to determine what to return.
  We also use the `let` expression to match the tuple returned.
#### Typing from Expression
Using steps to breakdown the expression is useful for determining types. <br>
Follow the steps with this expression: 
`fun a b c d -> if c || d then b *. b else if c then b else a`
* **Find the number of inputs.** 
    - There are 4 inputs
    - `(?->?->?->?->?)`
* **Follow the expression to find variable types.** 
    - `c` and `d` use `||` so they must be type bool. `b` uses `*.` so it must be type float. 
    - `(?->float->bool->bool->?)`
* **Use syntax rules to infer more types.**
    - if-statements need matching return types for then and else. Since `b` is type float `a` must be type float as well.
    - `(float->float->bool->bool->?)`
* **Find final return type.**
    - Trace through the expression to find the type of what is returned. Here it would be a float returned from the if-statement.
    - `(float->float->bool->bool->float)`
#### Expression from Type
Similarly, using steps to form an expression from a type is useful. <br>
Follow the steps with this type:
 `('a -> 'b) -> 'a -> 'b -> bool`
* **Find the number of inputs**
     - There are 4 types total so 3 of them are inputs
     - `fun x y z -> ?`
* **Try to make expressions for each of the inputs separately**
    - `x` is a function taking a `'a` and returning a `'b` . `y` is type `'a` so the expression `x y` would give the correct type. 
    - `z` is type `'b` so the result of `x y` would be the same type. 
    - `fun x y z -> (x y) ? z`
* **Make the expressions fit the return type**
    - Using bool operator `=` the type will be bool.
    - `fun x y z -> (x y) = z`
### Practice
* ``fun b d c a -> ((not d) || (d && d)) || a -. b = if c then b else a``
* ``fun a b c d e -> (e :: d, c a b)``
* ``fun a b c d e f g -> g > f || if e < d then not c else b > a``
* ``(int -> bool) -> int -> bool list``
* ``('a list -> 'b) -> 'a -> 'b -> 'a -> 'b``
* ``('a -> 'a list) -> ('a -> 'a) -> 'a -> 'a * 'b list -> 'a``

---
### Additional Resources
* [Discussion](https://github.com/cmsc330fall24/fall2024/blob/main/discussions/discussion2.md)
* [Expression to Type](https://nmittu.github.io/330-problem-generator/type_of_expr.html)
* [Type to Expression](https://nmittu.github.io/330-problem-generator/expr_of_type.html)

## Higher Order Functions (25 mins)

### Anonymous Functions
 * Use `fun` to make a function with no name; you cannot refer to it later
   * `fun x -> x + 3`
 * `let` for functions is a syntactic shorthand
   * `let f x = body` is semantically equivalent to `let f = fun x -> body`

#### Partial Application
Partial application means to create a new function by fixing some arguments of an existing function. This new function can then be called with the remaining arguments later.
Consider the following functions:

```ocaml
let plus x y = x + y (* int −> int −> int *)

let plus x = fun y −> x + y
(* int −> (int −> int) *)
(* int −> int −> int *)

let plus = fun x -> fun y -> x + y
(* int −> int −> int *)
```
In OCaml, every function technically only takes one argument, and to achieve the effect of multiple arguments, 
functions are designed to return another function, essentially creating a chain of single-argument functions.

### Passing Functions as Arguments
 * HOFs take one or more functions as arguments and/or return a function as its result

```ocaml
let multiply2 x = x * 2  (* int -> int *)
```

What's the type of this function?
```ocaml
let apply_twice f z = f (f z)
```

<details>
<summary>Click me!</summary>

```
('a -> 'a) -> 'a -> 'a
```
</details>

```ocaml
(* Pass the function multiply2 as an argument to function apply_twice *)
apply_twice multiply2 3  (* 12 *)

(* The function apply_twice will apply multiply2 to 3 two times *)
apply_twice multiply2 3
multiply2 (multiply2 3)
multiply2 6
12
```

### Map
Map applies a function to each item in a list (or another structure) without changing the structure itself. In `map f l`, 
the function `f` changes each value in the list `l`, but the list stays the same in order and shape. Mapping only changes the values, not the structure!

```ocaml
let rec map f l = 
  match l with
  | [] -> []
  | h::t -> (f h)::(map f t)

(* ('a -> 'b) -> 'a list -> 'b list *)

let numbers = [1; 2; 3; 4]
let result = map (fun x -> x * 2) (map (fun x -> x * x) numbers)
```
<details>
<summary>What is the value of result?</summary>

```ocaml
[2; 8; 18; 32]
```
</details>

What is the type of this function?
```ocaml
fun x y -> map (x y) ["a"]
```

<details>
<summary>Click me!</summary>

```ocaml
('a -> string -> 'b) -> 'a -> 'b list
```

* Since `x` takes `y` as an argument, `x`'s first parameter and `y` must have the same type: `'a`
* The expression `(x y)` is passed to map, meaning it must be a function
* Since map applies `(x y)` to each element of `["a"]` (a string list), `(x y)` must have type `string -> 'b`. This means `x` must have type `'a -> string -> 'b`
* Since map returns a new list, we know it will return `'b list`

Putting it together:
```
x: ('a -> string -> 'b)
y: 'a
return: 'b list
```
</details>

### Fold
 * fold replaces the constructor(s) of a type with the corresponding function argument
 * fold_left goes from left to right and fold_right goes from right to left
 * ``List.fold_left (fun a x -> "(" ^ a ^ "+" ^ x ^ ")") "0" ["1";"2";"3"] = "(((0+1)+2)+3)"``
 * ``List.fold_right (fun x a -> "(" ^ x ^ "+" ^ a ^ ")") ["1";"2";"3"] "0" = "(1+(2+(3+0)))"``
 * ``List.fold_left (fun a x -> "(" ^ x ^ "::" ^ a ^ ")") "[]" ["1";"2";"3"] = "(3::(2::(1::[])))"``
 * ``List.fold_right (fun x a -> "(" ^ x ^ "::" ^ a ^ ")") ["1";"2";"3"] "[]" = (1::(2::(3::[])))``
[Fold review.pdf](https://github.com/user-attachments/files/19078511/Fold.review.pdf)

## Imperative OCaml (20 mins)
- Functional programming encourages mathematical (functional) reasoning
	* e.g., Referential transparency:
	    * $x = y\Longrightarrow f(x)=f(y)$
	    * $f(x) + f(x) + f(x) = 3\cdot f(x)$
	    * Can replace every instance of a function with its evaluation — nothing else to worry about
- States are immutable once created (updates create a new state)
- Instead of control structures, uses recursion and higher-order reasoning — passing functions and returning functions as arguments 
- Realistically, sometimes we want values to change
	* e.g., Implementing a counter
- While OCaml variables are immutable, it has references, mutable fields, and arrays which are mutable

### References
- Three reference operators
	i. `ref`
    - Type: `'a -> 'a ref`
	- Allocates a reference
	    ```ocaml
        ref <expression>
        ```
        - Evaluates `<expression>` to a value `v`
        - Allocates a new *location* in memory to hold `v`
        - Stores `v` in that location
        - Returns that *location* (type `'a ref`)
        <details>
        <summary><b>Image</b></summary> 
    
        ![Screenshot 2025-03-01 031709](https://hackmd.io/_uploads/By-oGBxokl.png)
        </details>

    ii. `!`  
    - Type: `'a ref -> 'a`
    - Reads a reference
        ```ocaml
        !<expression>
        ```
        - Evaluates `<expression>` to a *location*
        - Returns contents of memory at that location
        <details>
        <summary><b>Image</b></summary> 

        ![Screenshot 2025-03-01 031804](https://hackmd.io/_uploads/BJfAMrlikx.png)
        </details>

    iii. `:=`
    - Type: `'a ref -> 'a -> unit`
    - Changes a value stored in a reference
        ```ocaml
        e₁ := e₂
        ```
        - Evaluates e₂ to a value v₂
	    - Evaluates e₁ to a *location*
	    - Store v₂ in contents of memory at that *location*
	    - Return `unit ()`
	    <details>
        <summary><b>Image</b></summary> 

        ![Screenshot 2025-03-01 141627](https://hackmd.io/_uploads/HJuv6Cgikx.png)
        </details>

<details>
<summary><b>Note</b></summary>  
If we said
    
```ocaml
let x = ref 5
```
    
<img src="https://hackmd.io/_uploads/By-oGBxokl.png" alt="image">
    
Then `x` __itself__ is *immutable*; but the __location__ `x` references is *mutable*.
```ocaml=
x := 6 (* changes the reference *)
let x = ref 6 (* shadows the old x *)
```
<img src="https://hackmd.io/_uploads/BJVyKrlo1g.png" alt="image">
</details>

---
<details>
<summary><b>Example: Aliases</b></summary>  
    
![Screenshot 2025-03-01 034432](https://hackmd.io/_uploads/BJLZYHeikg.png)

> What does `x` evaluate to?  
> What does `y` evaluate to?  
> What does `!z` evaluate to?  
</details>

### Sequences

Syntax:
```ocaml
<expression 1> ; <expression 2>
```

- Evaluates `<expression 1>` to a value v₁
- Evaluates `<expression 2>` to a value v₂
- Returns v₂
    - Note that this throws away v₁ — so `<expression 1>` is only ever useful if it has side effects
    ```ocaml
    let x = print_string "a" ; 3
    ```
    Why couldn't we do `print_string "a" ; let x = 3`?
    <details>
    <summary><b>Solution</b></summary>
    
    `let` is a binding of the form `let x = <expression>`, so the "expression" is `3` — not `let x = 3`!
    </details>
  
---
<details>
<summary><b>Example: Counter</b></summary>     
    
![Screenshot 2025-03-01 034551](https://hackmd.io/_uploads/rJG8YBli1e.png)

</details>

### Evaluation Examples
    
```ocaml=
let f b =
     let a = ref 0 in
         a := !a + b; !a
         in (f 5) + (f 5)
```
<details><summary><b>Solution</b></summary>     
10
</details>
    
    
```ocaml=
let f =
     let a = ref 0 in
         fun b -> a := !a + b; !a
         in (f 5) + (f 5)
```
<details><summary><b>Solution</b></summary>     
15
</details>
    
### Typing Examples
    
```ocaml=
let rec f a =
    let x = ref "hi" in
        fun b -> a := !x ^ b; 4
```
<details>
<summary><b>Solution</b></summary>    
    
`string ref -> string -> int`
</details>
    
    
```ocaml=
let rec f (x::xs) b = 
    x := !b + !x
```
<details>
<summary><b>Solution</b></summary>    
    
`int ref list -> int ref -> unit`
</details>

### Functions with Imperative
- First consider two simple examples:
    
```ocaml
    (* x is a variable bound to a non-function value. *)
    let x = print_int 5;;
    (* This let statement itself does print 5 when called, *)
    (* because it needs to execute the printing to get its value *)
    
    (* Will not print 5 - the value was already gotten and stored *)
    x;;
    x;;
    x;;
    
    (* y is a variable bound to a function *)
    (* one step in the function is printing *)
    let y _ = print_int 5;;
    (* This let statement itself does NOT print 5 when called, *)
    (* because it cannot execute the function without being given an argument *)
    
    (* note: because OCaml does currying by default, the above is equivalent to... *)
    let y = fun _ -> print_int 5;;
    
    (* Will not print 5 - the value is the whole function *)
    y;;
    y;;
    y;;
    
    (* Will print 5 - the function is excuted bc it's given an argument *)
    y ();;
    y 4;;
    y "hehe";;
```
- What's going on here?
    - `x` is bound to the value `()` with type `unit`.
        - The `print_int 5` is evaluated exactly once, and that's at the moment `x` is bound. So `5` is printed at the binding, but...
        - When `x` is referred to again later, it doesn't re-print `5`.
        - It didn't store the act of printing `5`, it only stored `()`.
    
    - `y` is bound to the value `fun _ -> print_int 5`, which has type `'a -> unit`. 
        - The `fun _ -> print_int 5` is *not* actively executed when you define the function. 
            - It can't be, since it expects a parameter but doesn't get one. It's just stored in memory as a whole function.
        - When `y` alone is referred to again later, it also doesn't re-print `5`, again because it isn't given a parameter, and thus no function execution can happen.
        - **However**, if the function `y` is called with an argument, the function *is* executed with that argument. 
            - The application evaluates to `()` of type `unit`. 
            - And part of that evaluation process is executing the function code, which prints `5`!
    
- Okay, what about if we nest those two together? Instead of first defining `x` then defining `y`, let's define `x` inside `y`.
    
```ocaml
    (* This definition will only print 7 when first defined. *)
    let y = 
        let x = print_int 7 in
        fun _ -> print_int 8;;
    
    y ();; (* Will only print 8 *)
    y ();; (* Will only print 8 *)
    y;; (* does not print, evaluates to a function *)
```
    
- What's going on here?
    - It's exactly the same as before. The fact that the `x` binding is nested inside `y`'s definition *does not matter* (all it changed was the scope of `x`).
    - The `let y =` says: "whatever the value of the following is, store it in `y`".
        - The `let x = print_int 7 in` says "by the way, I'm doing this variable binding of `x` that may or may not be used `in` the next bit"
            - As before, this will print `7`, since it has to run `print_int 7` to get the value `()` which is stored in `x`.
            - Then that `x` binding may or may not be used `in` the next follwoing expression
        - The final expression is `fun _ -> print_int 8`, which is just a function, like before.
    - TL;DR: `y` is bound to the function `fun _ -> print_int 8`, **not** bound to the act of setting a variable `x` *and* the value of the function.
    - So the `7` was printed only once, (the first time OCaml tried to evaluate what it should store in `y`), and never again.
        - Like last time, when `y` is called alone, it's just the function value with no arguments provided, and so it can't execute the function and doesn't print anything.
            - Again, `7` is not printed, because that only was evaluated the one time. `y` only stores the value of the whole expression, which is just a function.
        - When `y` is called with an argument, it actually executes the function, which prints `8`.
    
- Hopefully, this helps you understand the lecture quiz 4 counters a little more: they are the exact same concept, but instead of `print_int 7` being the imperative expression with a side effect and a value of `()` being executed, `ref 0` or `count := !count + 1` are the imperative expressions with a side effect and a value of `()` being executed.
    
    - Here they are for reference:
    
```ocaml
    let new_num = 
        let count = ref 0 in (* 1: set count to point to somewhere that holds 0 *)
        (* function def (actual value of new_num) starts here *)
        fun () -> (* runs every time new_num called with an arg *)
            let res = !count in (* 2: set res to what count points at currently*)
            count := !count + 1; (* 3: increment what count points at *)
            res;; (* 4: return res *)
    
    (* step 1: the 'count' variable being set to 0; executes exactly once, *)
    (* since it's not part of the function bound to new_num.  *)
    (* That execution already happened during the defining above, *)
    (* just like 7 was printed only once in the previous example *)
    
    new_num ();; (* steps 2,3,4 execute, 0 is returned *)
    new_num ();; (* steps 2,3,4 execute, 1 is returned *)
    new_num;; (* nothing executes *)
    new_num ();; (* steps 2,3,4 execute, 2 is returned *)
```
    
- The only concept here to be careful of is that closures matter here, in that the function 
    `fun () -> let res = !count in count := !count + 1; res;;`
    is stored as a "closure", which just means...
    - It does NOT just throw an `Unbound value count` error every time it's used since `count` was only defined in that one scope.
    - It DOES just store the memory address that `count` represents alongside the function, and use that directly instead of looking for the value of `count` based on where it's called.
    
- A closure is just the way functions are stored in memory in OCaml - that is, store the function itself, *and* the environment (list of variable bindings that were true and relevant at the time the function was defined).
    
```ocaml
    let new_num () = 
        (* function def already started - new_num directly expects an argument *)
        let count = ref 0 in (* 1: set count to point to somewhere that holds 0 *)
        let res = !count in (* 2: set res to what count points at currently*)
        count := !count + 1; (* 3: increment what count points at *)
        res (* 4: return res *)
    
    (* step 1: is now part of the function bound to new_num, *)
    (* and will execute when new_num is called with an argument *)
    (* not just the one time like before *)
    
    new_num ();; (* steps 1,2,3,4 execute, 0 is returned *)
    new_num ();; (* steps 1,2,3,4 execute, 0 is returned *)
    new_num;; (* nothing executes *)
    new_num ();; (* steps 1,2,3,4 execute, 0 is returned *)
```
        
- Complex example 2: Multi-argument functions (= curried functions)!
    
```ocaml
    let y = 
        fun a -> 
            let _ = print_int 7 in
        fun b -> 
            print_int 8;;
    
    y () ();; (* prints 78, evaluates to `()` of type `unit`*)
    y;; (* does not print, evaluates to a function of type `'a -> 'b -> unit`*)
    
    (* Harder: see spoiler text *)
    y ();; (* prints 7 only, evaluates to a function (will not ask type of this)*)
```
    
- What's going on here?
    - `y` is bound to a chain of 2 functions. This means that `y` can be considered a single, 2-argument function of type `'a -> 'b -> unit`. It takes in two arguments, `a` and `b`.
        - Similar to `let f x y = x + y` equating to `let f = fun x -> fun y -> x + y`.
    - Just like before, `y` is a function that expects some args. If it's called with those args, all parts of the function will execute. 
        - So `y` expects two arguments for its two parameters, `a` and `b`, and if it gets both of those, all parts of the two-parameter function execute - so `7` is printed, then `8` is printed.
    
        <details><summary><b>Partial Applications?</b></summary>
            This is pretty cool!
            
                - I have a function 
            `let f = fun a -> fun b -> a + b`.
                    - Regular call: `f 4 5` = `9`
                    - Partial call: `f 4`. It will...
                    - Pass 4 into the `a` parameter, 
                    - execute the first function in the chain with that parameter 
                        - in this case that first function just returns `fun b -> a + b` without doing anything else
                    - Result: `fun b -> 4 + b`.
                - Same in our imperative examle! I have a function 
            `let y = fun a -> let _ print_int 7 in fun b -> print_int 8`.
                    - Regular call: `y 4 5` = `()`, prints `7` and `8`. 
                    - Partial call: `y 4`. It will...
                    - Pass 4 into the `a` parameter,
                    - execute the first function in the chain with that parameter 
                        - in this case that first function will first print `7`, 
                        - then return `fun b -> a + b`
                    - Result: `fun b -> print_int 8`. Only `7` was printed.
        </details>

- Example of what this could look like with a reference:
    
```ocaml
    let y = 
        fun a -> 
            let x = ref 7 in
        fun b -> 
            print_int !x;
            x := 44;;
    
    y () ();; (* prints 7, evaluates to `()` of type `unit`*)
    y () ();; (* prints 7, evaluates to `()` of type `unit`*)
    y () ();; (* prints 7, evaluates to `()` of type `unit`*)
```
    
- Notable thing here:
    - Just like how in the previous example, the first in the chain of functions always executed when `y` is called with 2 args, and so printed `7`...
        - Here the same happens and so the reference to `7` is set.
    - OR, just like how in the broken `new_num` counter example, setting a reference to 0 happened when `new_num` was called with an argument...
        - Here the same happens when `y` is called with 2 args, and so the reference to `7` is set every time.

## Property Based Testing (20 mins)
* Unit testing suffers from a very particular limitation: you have to think of the things to check.
* The idea that we can test code based on properties they must uphold rather than specific inputs. 
* Example: What are some properties of a function that is meant to reverse a list? <details><summary>properties</summary>
  - Length of the reversed list = length of original list
  - Reversing the list twice will result in the original list
  - The set of elements in the reversed list should equal the set of elements in the original list
  - etc.
</details>

* QCheck tests are described by
  - A generator that generates random input for our tests 
  - A property → bool valued function
* When given questions regarding PBT, there are 3 aspects that we must consider: 
  - the validity of the **property itself** in describing what the function is supposed to do (the correct implementation of the function would uphold the property)
  - the validity of the **implementation** of the property (implementation of property represents property)
  - whether the implementation of the **function** upholds the property (the code that may or may not be buggy will always return true when tested against the property)

* These are mostly independent of each other! Consider we are given 4 elements:
  - The property `p`
  - The goal of a function `f` (what `f` is supposed to do)
  - The implementation of `f`, which we can call `I(f)` (the actual code written in an attempt to obtain `f` -> may or may not be buggy)
  - The implementation of `p`, which we can call `I(p)` 

* When asked about the validity of the property, we only consider `p` and `f`
* When asked about the validity of the implementation of the property, we only consider whether `I(p)` matches `p`
* When asked whether the implementation of the code upholds the property (or will the property "catch bugs"), we only consider how `p` correlates to `I(f)`

**Example Problems:**

***First:*** Quiz 2 PBT Problem! (See solutions)

***Next:*** Recall the `count_occ` function from project 1: it is supposed to take in a `lst` and `target` and return how many elements in `lst` are equal to `target`. (This is the goal of the function, `f`, from above)

Below is an implementation (`I(f)`) of `count_occ`:

```ocaml
let count_occ lst target = List.fold_left (fun x y -> if y = target then y + 1 else x) 0 lst;;
```

The property (`p`) we have identified is:  the result of count_occ will always be less than or equal to the length of the list.

Our implemenation of `p` (`I(p)`) is: `count_occ lst target <= List.length lst` 

- Is the property `p` valid?
- Is the implementation of the property `p` correct?
- Does the implementation of `count_occ` maintain property `p`?

## Regular Expressions (25 mins)
* A pattern that describes a set of strings
* Defines a regular language, which can be created from a finite state machine
* Creating regular expressions
    - `ab` -> a **and** b
    - `a|b` -> a **or** b
    - `[abc]` -> a **or** b **or** c
    - `[^abc]` -> anything except a, b, c
    - `[a-z]` -> all lowercase letters
    - `[A-Z]` -> all uppercase letters
    - `[0-9]` -> every digit from 0 to 9
        * Observe, `[r1-r2]` is a range specification <details><summary><b>What does [A-z] match?</b></summary> All characters with ASCII codes between A and z (including [, \, ], ^, _, and `)</details>
    - `(cs|ece)` -> capture "cs" **or** "ece"
        * <details><summary><b>What if we did "[cs|ece]"?</b></summary> Will capture "c", "s", "|", or "e"</details>
    -  `.` ->  any character
    -  `*` -> zero or more repetitions of the preceding character or group
    -  `+` -> one or more repetitions of the preceding character or group
    -  `?` -> zero or one repetitions of the preceding character or group
    -  `{n}` -> exactly n repetitions of the preceding character or group
    -  `{m, n}` -> at least m and at most n repetitions of the preceding character or group
    -  `{n,}` -> at least n repetitions of the preceding character or group}
    -  `\s` -> matches to any whitespace
    -  `\d` -> matches to any singular numeric character. Equivalent to `[0-9]`
    -  `\w` -> matches to any alphanumeric character including underscore. Equivalent to `[A-Za-z0-9_]`
    - `^` -> begins with
    - `$` -> ends with

- Remember to escape special characters
    -  Ex. `\(`,  `\)`, `\.`, `\?`, `\+`, `\/`, `\*`, etc.
  
* A regex cheat sheet will be provided on the exam!
  <img width="898" alt="Screenshot 2025-03-04 at 11 39 10 AM" src="https://github.com/user-attachments/assets/77c7d153-5f6b-4cb2-86d7-4e41b2b87cc1" />

* Commonly made mistakes (credits to Maya Popova):
    -  Using `[]` instead of `()`
	* `(hi|bye)` - "match 'hi' or 'bye'"
	* `[hi|bye]` - "match 'h' or 'i' or '|' or 'b' or 'y' or 'e'"
    -  Forgetting how `|` scoping works
    -  Forgetting how `*` and `+` scoping works
    -  Forgetting that `^` works differently inside `[]` and outside
    -  Forgetting to escape `.` and `(` and `)` and `\` and `*` and `+`
    -  Trying to be clever about ASCII values

* Some examples
  * Which of these strings match the following regular expression?
    `^[A-Z]*[a-z]+\s?.[0-9]+$`
    * Cmsc:330
    * CMSC.330
    * cliff 987
    * anwar:00001a
    * alan 3
    <details><summary><b>Answer:</b></summary> 
    Only Cmsc:330, cliff 987, and alan 3
</details>

  *  Write a regular expression that accepts `id: XXX-XX-XXXX codename: <codename>`, where each `X` represents a digit and `<codename>` is a string **beginning with an uppercase letter** that may have additional uppercase **and/or** lowercase letters after it.
   
     For example, the following strings should be accepted:    
       - id: 669-98-3600 codename: Watch
       - id: 123-45-6789 codename: McGregor
       - id: 972-35-6200 codename: Minsi
        
     The following strings should be rejected:        
       - id: 123456789 codename: Wrong
       - id: 987-65-4321 codename: nope
       - id: 271-82-8182 codename: Alan3
       <details><summary><b>Answer:</b></summary> 
        ^id: [0-9]{3}-[0-9]{2}-[0-9]{4} codename: [A-Z][A-Za-z]*$</details>

  * Write a regex that describes a subset of valid UMD emails. Emails take the form of a user’s directory ID followed by the @ symbol, followed by one of the following domain names: cs.umd.edu, terpmail.umd.edu, or just umd.edu.
    
     Additional constraints: 
       - A user’s directory ID can be length 1 to length 8 consisting of only alphanumeric (both upper and lowercase) characters.
       - A user’s directory ID may not start with an uppercase letter.
       - A user's directory ID must end with a digit.

       <details><summary><b>Answer:</b></summary> 
        ^([a-z0-9][A-Za-z0-9]{0,6})?[0-9]@((cs\.|terpmail\.)?umd\.edu)$</details>

  * Write a regex that describes a subset of valid mathematical expressions using the basic operations `+ - * /` and positive integers. Our expressions will begin with a positive integer, and may alternate between operations and positive integers before finally ending with a positive integer. Our expressions may also begin and end with matching parenthesis `(` `)`.

    For example, the following strings should be accepted:    
       - 1
       - 12*2+3/44
       - (100+2-3/4+5)
       - 0003+0102
        
     The following strings should be rejected:        
       - 1+
       - +4*4
       - (1+100/2
       - 1++32

       <details><summary><b>Answer:</b></summary> 
        ^[0-9]+([\-/+*][0-9]+)*|\([0-9]+([\-/+*][0-9]+)*\)$</details>
        
  * Write a regex that describes a set of numbers in scientific notation. There must be single non-zero digit before the decimal place, and there must be at least 1 digit after the decimal place. Following the digits, we must have "e" and then either a positive or negative integer exponent indicated by a preceeding `+` and `-`, respectively.

    For example, the following strings should be accepted:    
       - 6.22e-23
       - 5.5e-10
       - 3.141592658979e+1
       - 1.000000e+0000
        
     The following strings should be rejected:        
       - 0
       - 0.5e-23 (begins with zero)
       - 1e+10 (no decimal point)
       - 1.0 (no exponent)

       <details><summary><b>Answer:</b></summary> 
        ^[1-9]\.[0-9]+e(\+|-)[0-9]+$</details>

  * Write a regex that matches all integers from 0 to 1 million, inclusive. The integer should not have leading zeros, unless it is just 0.

    For example, the following strings should be accepted:    
       - 0
       - 999999
       - 1000000
        
     The following strings should be rejected:        
       - 1000001
       - 1023509870

       <details><summary><b>Answer:</b></summary> 
        ^0|1000000|[1-9][0-9]{0,5}$</details>

* Regular Expressions in OCaml      
  * You need to include the re library. (https://ocaml.org/p/re/1.10.4/doc/Re/index.html)
    ```
    #require "re" (* only in utop *)
    let comp_re = Re.compile (Re.Posix.re "I am ([0-9]+) years old") in 
    let matched = Re.exec comp_re "I am 23 years old" in 
    print_string ("Age: " ^ (Re.Group.get matched 1))
    ```
## Finite State Machines, NFA-DFA (25 mins) 

### What are FSMs?
1) A **finite-state machine** (FSM) or finite-state automata (FSA) is a **model** of certain types of computation. The machine can **be in exactly one "state"** at a time, and **can change** which state it's on **when it recieves input**.
2) FSMs are considered a subset of pushdown automata, which are themselves a subset of turing machines. Turing machines are capable of modeling any computer algorithm - FSMs can only model some.
3) FSMs can be represented by a 5-element tuple:
    - **Set** of all **possible states**
    - A **starting state** — There can be only 1 starting state
    - **Set** of **final or accepting states**
    - **Set** of **transitions** — (initial_state, letter from alphabet, ending_state)
    - **Alphabet** — set of all symbols that representing valid transitions

### FSMs and Regex
- Every regular expression (and in fact, **all regular languages**) **can be represented as FSMs**, and vice versa.
  - A string accepted by the language taken as input would put the machine into a final (accepting) state.
  - A string not accepted by the language taken as input would put the machine into a non-final state (or into the garbage state).

### Classifying FSMs (DFA vs. NFA)
FSMs can be described based on whether they are deterministic.
- **DFA** (Deterministic Finite Automata)
  - "Deterministic" means that the exact output state from any given input state and symbol is pre-*determined*.
  - This means at any given state with any given input, there is **no ambiguity** as to what state comes next.
    - DFAs **cannot have explicit epsilon transitions**. If they did, then it would be ambiguous whether the machine should be at the current state or at a state it can lead to using an epsilon transition.
    - DFAs **cannot have more than one transition with the same symbol out of the same state**. If they did, then it would be ambiguous which path the machine should follow when given that symbol as input.
- **NFA ( Nondeterministic Finite Automata )**
  - "Non-deterministic" means that the exact output state from any given input state and symbol may **not** be pre-determined.
  - This means at any given state with any given input, there **may be ambiguity** as to what state comes next.
  - NFAs are considered a superset of DFAs. That is, **every DFA is also considered an NFA, but not every NFA is a DFA**.
    - In short, "All DFAs are NFAs, but not all NFAs are DFAs".

What's the difference in practice? 
- Due to ambiguity in the number of output possibilities it is generally **more expensive** to check for string acceptance in NFAs.
  - We must check to verify if *any* possible path leads to an accepting state. If any path does, the NFA is considered to accpet that string.
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
![IMG_52724B54B9A9-1 (1)](./imgs/39cc426f-3928-48bc-b4b2-30cff10a61cc.png)
![IMG_29553EDBEF31-1 (1)](./imgs/5ab52f09-e7c7-4309-bf3b-5d23746ab998.png)
![IMG_9950FF5DEE1E-1 (1)](./imgs/0467aad3-26b3-4100-9d4f-c0ba89918b55.png)

### Collected problems from past assessments:

1) 
<img width="704" src="./imgs/2e3f7421-5429-4907-82de-3d84fc1123a2.png">

2) Make this a regex to nfa problem
<img width="657"  src="./imgs/ab03455b-0b7b-4735-b127-050ead3f632b.png">

3) 
<img width="687" src="./imgs/nfadfa.png">
