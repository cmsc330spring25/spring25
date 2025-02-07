# Discussion 2 - Friday, February 7th

## Reminders

1. Quiz 1 next **Friday, February 14th**
   1. Quizzes will start **at the beginning of discussion** and you will have **25 minutes** to complete it.
   1. Topics will be announced soon on Piazza.
3. Project 1 due **Monday, February 12th @ 11:59 PM**
4. Quiz makeup policy: [@8](https://piazza.com/class/m6687mvdhig1iw/post/8)
   1. Quiz makeups will be at the **start of your assigned lecture time** immediately following a quiz.
   1. Quiz Makeup Location: **IRB 2137**
   1. MUST submit documentation — see Piazza post for details
5. When attending office hours, you must sign into quuly and put yourself in the queue so on-duty TAs know you need help.
    1. The student join code is **d97a2**    


## Exercises

### OCaml Lists and Pattern Matching
1. Write the following functions in OCaml **using recursion**:

   ### `remove_all lst x`

   - **Type:** `'a list -> 'a -> 'a list`
   - **Description:** Takes in a list `lst` and returns the list `lst` without any instances of the element `x` in the same order.

   ```ocaml
   remove_all [1;2;3;1] 1 = [2;3]
   remove_all [1;2;3;1] 5 = [1;2;3;1]
   remove_all [true; false; false] false = [true]
   remove_all [] 42 = []
   ```

<details>
    <summary>Solution</summary>

    let rec remove_all lst x = match lst with
        | [] -> []
        | h::t -> if x = h then (remove_all t x) else h::(remove_all t x);;
    
</details>

   ### `index_of lst x`

   - **Type:** `'a list -> 'a -> int`
   - **Description:** Takes in a list `lst` and returns the index of the first instance of element `x`.
   - **Notes:**
     - If the element doesn't exist, you should return `-1`
     - You can write a helper function!

   ```ocaml
   index_of [1;2;3;1] 1 = 0
   index_of [4;2;3;1] 1 = 3
   index_of [true; false; false] false = 1
   index_of [] 42 = -1
   ```

<details>
    <summary>Solution</summary>
    
    let index_of lst x = 
        let rec helper lst x i = match lst with
        | [] -> -1
        | h::t -> if x = h then i else (helper t x (i + 1)) 
    in helper lst x 0;;
</details>
<br>

2. Give the type for each of the following OCaml expressions:

   > **NOTE:** Feel free to skip around, there are a lot of examples! 🙃

   ```ocaml
   [2a] fun a b -> b < a

   [2b] fun a b -> b + a > b - a

   [2c] fun a b c -> (int_of_string c) * (b + a)

   [2d] fun a b c -> (if c then a else a) * (b + a)

   [2e] fun a b c -> [ a + b; if c then a else a + b ]

   [2f] fun a b c -> if a b != a c then (a b) else (c < 2.0)

   [2g] fun a b c d -> if a && b < c then d + 1 else b
   ```

<details>
    <summary>Solution</summary>
    
    [2a] 'a -> 'a -> bool

    [2b] int -> int -> bool

    [2c] int -> int -> string -> int

    [2d] int -> int -> bool -> int

    [2e] int -> int -> bool -> int list

    [2f] (float -> bool) -> float -> float -> bool

    [2g] bool -> int -> int -> int -> int
</details>
<br>

3. Write an OCaml expression for each of the following types:

   ```ocaml
   [3a] int * bool list

   [3b] (int * float) -> int -> float -> bool list

   [3c] float -> string -> int * bool

   [3d] (int -> bool) -> int -> bool list

   [3e] ('a -> 'b) -> 'a -> 'a * 'b list

   [3f] ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c

   [3g] 'a -> 'b list -> 'a -> 'a * 'a
   ```

<details>
    <summary>Solution</summary>
    
    [3a] (1, [true])
    (* NOTE: same thing as `int * (bool list)` *)

    [3b] fun (a, b) c d -> [a + 1 = c; b +. 1.0 = d]

    [3c] fun a b -> (int_of_float a, b = "a")

    [3d] fun f a -> [f a; a = 2]

    [3e] fun f a -> (a, [f a])

    [3f] fun f g a -> g (f a)

    [3g] fun a b c -> if (a = c && b = []) then (a,a) else (c,c)
</details>
<br>

4. Give the type of the following OCaml function:

   ```ocaml
   let rec f p x y =
   match x, y with
      | ([], []) -> []
      | ((a,b)::t1, c::t2) -> (p a c, p b c)::(f p t1 t2)
      | (_, _) -> failwith "error";;
   ```

<details>
    <summary>Solution</summary>
    
    ('a -> 'b -> 'c) -> ('a * 'a) list -> 'b list -> ('c * 'c) list
</details>
<br>

5. What values do `x`, `y`, and `z` bind to in the following code snippet?

   ```ocaml
   let x = match ("lol", 7) with
      | ("haha", 5)  -> "one"
      | ("lol", _)   -> "two"
      | ("lol", 7)   -> "three"
   ;;

   let y = match (2, true) with
      | (1, _)       -> "one"
      | (2, false)   -> "two"
      | (_, _)       -> "three"
      | (_, true)    -> "four"
   ;;

   let z = match [1;2;4] with
      | []           -> "one"
      | 2::_         -> "two"
      | 1::2::t      -> "three"
      | _            -> "four"
   ;;
   ```

<details>
    <summary>Solution</summary>
    
    x: two
    y: three
    z: three
</details>
<br>

### Higher Order Functions (Map & Fold)

Consider the following higher order functions:

```ocaml
let rec map f xs =
  match xs with
    | [] -> []
    | h::t -> (f h)::(map f t)

let rec fold f a lst =
  match lst with
    | [] -> a
    | h::t -> fold f (f a h) t

let rec fold_right f lst a =
  match lst with
    | [] -> a
    | h::t -> f h (fold_right f t a)
```

#### Map vs Fold
Both `map` and `fold` are higher-order functions, but are used in different scenarios.

##### `map`
`map` is a structure-preserving operation, meaning that it applies a function to each element of a list and returns a new list of the same structure but with the new values. 

##### `fold`
`fold` processes the structure from either the left (`fold_left`) or the right (`fold_right`), and uses an accumulator to combine the elements through a given function, ultimately reducing the structure to a single value.

Write the following functions using either `fold`, `fold_right`, and / or `map`:

#### `list_square nums`

- **Type**: `int list -> int list`
- **Description:** Given a list of integers `nums`, return a list where each value is squared.
- **Examples:**

```ocaml
list_square [1; 2; 3; 4] = [1; 4; 9; 16]
list_square [0; 5; 6] = [0; 25; 36]
list_square [] = []
list_square [-3; -2; -1] = [9; 4; 1]
```

<details>
    <summary>Solution</summary>
   
    let list_square nums = map (fun x -> x * x) nums
</details>
<br>

#### `swap_tuples tuples`

- **Type**: `(int * int) list -> (int * int) list`
- **Description:** Given a list of two element tuples, swap the first and second elements of each tuple.
- **Examples:**

```ocaml
swap_tuples [(1, 2); (3, 4)] = [(2, 1); (4, 3)]
swap_tuples [(5, 10); (7, 8)] = [(10, 5); (8, 7)]
swap_tuples [(0, 0)] = [(0, 0)]
```

<details>
    <summary>Solution</summary>
   
    let swap_tuples tups = map (fun (a,b) -> (b,a)) tups
</details>
<br>

#### `list_product nums`

- **Type**: `int list -> int`
- **Description:** Given a list of `nums`, return the product of all elements in the list.
- **Examples:**

```ocaml
list_product [2; 5] = 10
list_product [3; 0; 2] = 0
list_product [] = 1
```

<details>
    <summary>Solution</summary>
   
    let list_product nums = fold (fun acc elem -> acc * elem) 1 nums
</details>
<br>

More information + examples can be found in the [Spring23 OCaml discussion](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d3_ocaml).

## Resources & Additional Readings

- Encouraged (but optional) readings
  - [Spring 2023 OCaml Discussion](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d3_ocaml)
  - [cs3110 - Expressions in OCaml](https://cs3110.github.io/textbook/chapters/basics/expressions.html)
- OCaml typing / expression generators
  - https://nmittu.github.io/330-problem-generator/type_of_expr.html
