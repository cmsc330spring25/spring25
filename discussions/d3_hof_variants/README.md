# Discussion 3 - Friday, February 14th

## Reminders

1. Quiz 1 **TODAY**, 25 mins
2. Project 2 due **Monday, February 24 @ 11:59 PM**

## Notes
For the next project, we have some review and practice of the following concepts:
- OCaml [`map`](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d4_hof#part-1-map) and [`fold`](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d4_hof#part-2-fold)
- OCaml records
- OCaml types & variants

## Exercises

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

Write the following functions using either `fold`, `fold_right`, and / or `map`:

#### `list_add x nums`

- **Type**: `int -> int list -> int list`
- **Description:** Given a number `x` and a list of integers `nums`, return `nums` with all of its values incremented by `x`.
- **Examples:**

```ocaml
list_add 1 [1;2;3;4] = [2;3;4;5]
list_add 3 [1;2;3;4] = [4;5;6;7]
list_add 1 [] = []
list_add (-3) [7;10] = [4;7]
```

<details>
  <summary>Solution!</summary>
  
```ocaml
let list_add x nums = map (fun num -> num + x) nums
let list_add x nums = map ((+) x) nums (* sillier version *)
```
</details>

#### `mold f lst`

- **Type**: `('a -> 'b) -> 'a list -> 'b list`
- **Description:** Rewrite the `map` function using `fold`
- **Examples**:

```ocaml
mold (fun x -> x = 3) [1;2;3;4] = [false;false;true;false]
mold (fun x -> x - 1) [1;2;3;4] = [0;1;2;3]
mold (fun x -> 0) [1;2;3;4] = [0;0;0;0]
mold (string_of_int) [1;2;3;4] = ["1";"2";"3";"4"]
```

- **Addendum:** What happens if we use `fold_right` instead of `fold`? How does this affect the order of iteration?

<details>
  <summary>Solution!</summary>
  
```ocaml
let mold f lst = List.rev (fold (fun a x -> (f x)::a) [] lst)
let mold f lst = fold (fun a x -> a @ [(f x)]) [] lst

(* Notice how we don't have to reverse the list! *)
let mold f lst = fold_right (fun x a -> (f x)::a) lst []
```
    
If we append to the accumulator using `(f x) :: a`, we are adding elements to the front of the list. Since fold processes the list from left to right, the output list will be made in reverse order. However, fold_right processes the list from right to left, which preserves the original order without needing to reverse it at the end. The order of iteration matters here!
</details>

#### `list_sum_product lst`

- **Type**: `int list -> int * int * bool`
- **Description**: Write a function that takes in an `int list` and returns an `int * int * bool` tuple of the following form:
  - The first element is the **sum** of the **even** indexed elements
  - The second element is the **product** of the **odd** indexed elements.
  - The third element is a boolean that will be **true** if the sum and the product are equal, otherwise **false**.
- **Note:** The list is 0 indexed, and 0 is an even index.
- **Examples**:

```ocaml
list_sum_product [] = (0,1,false)
list_sum_product [1;2;3;4] = (4,8,false)
list_sum_product [1;5;4;1] = (5,5,true)
list_sum_product [1;-2;-3;4] = (-2,-8,false)
```

<details>
  <summary>Solution!</summary>
  
```ocaml
let list_sum_product lst = 
  let (sum, product, index) = fold 
    (fun (even, odd, i) num -> 
      if i mod 2 = 0 
        then (even + num, odd, i + 1) 
        else (even, odd * num, i + 1)) 
    (0, 1, 0) lst 
  in (sum, product, sum = product);;
```
</details>

### Records

Consider the following custom record type, which is similar to the return tuple of `list_sum_product`:

```ocaml
type results = {
  sum_even: int;
  product_odd: int;
  num_elements: int;
}
```

#### `record_sum_product lst`

- **Type**: `int list -> results`
- **Description**: Similar to the `list_sum_product` function above, but returns a `results` record with the following fields:
  - `sum_even` is the **sum** of the **even indexed** elements
  - `product_odd` is the **product** of the **odd indexed** elements.
  - `num_elements` is the number of elements in `lst`
- **Note:** The list is 0 indexed, and 0 is an even index.
- **Examples**:

```ocaml
record_sum_product [] = {sum_even = 0; product_odd = 1; num_elements = 0}
record_sum_product [1;2;3;4] = {sum_even = 4; product_odd = 8; num_elements = 4}
record_sum_product [1;5;4;1] = {sum_even = 5; product_odd = 5; num_elements = 4}
record_sum_product [1;-2;-3;4] = {sum_even = -2; product_odd = -8; num_elements = 4}
```

<details>
  <summary>Solution!</summary>
  
```ocaml
let record_sum_product lst = 
  fold (fun {sum_even; product_odd; num_elements} num -> 
    if num_elements mod 2 = 0 
      then {
        sum_even = sum_even + num; 
        product_odd; 
        num_elements = num_elements + 1 } 
      else {
        sum_even; 
        product_odd = product_odd * num; 
        num_elements = num_elements + 1 })
  {sum_even = 0; product_odd = 1; num_elements = 0} lst;;
```
</details>


#### Another exercise! Consider the following custom record types:

```ocaml
type weather_data = {
    temperature: float;
    precipitation: float;
    wind_speed: int;
}

type cp_weather_report = {
    days: weather_data list;
    num_of_days: float;
}
```

#### `average_temperature report`

- **Type:** `cp_weather_report -> float`
- **Description:** This function takes a `cp_weather_report` record, containing a list of `weather_data` records from College Park and returns the average temperature of College Park.
- **Note:** If the `num_of_days` within `cp_weather_report` is 0 then return 0.0
- **Examples:**
 
```ocaml
let ex1 = {
  days = [
    { temperature = 70.0; precipitation = 0.2; wind_speed = 10 };
    { temperature = 68.0; precipitation = 0.1; wind_speed = 12 };
    { temperature = 72.0; precipitation = 0.0; wind_speed = 8 };
    { temperature = 75.0; precipitation = 0.3; wind_speed = 15 }
  ];
  num_of_days = 4.0
}
average_temperature ex1 = 71.25

let ex2 = {
    days = [];
    num_of_days = 0.0
}
average_temperature ex2 = 0.0

let ex3 = {
    days = [
    { temperature = 30.0; precipitation = 0.0; wind_speed = 3 };
    { temperature = 35.0; precipitation = 0.0; wind_speed = 4 }
  ];
  num_of_days = 2.0
}
average_temperature ex3 = 32.5
```

<details>
  <summary>Solution!</summary>
  
```ocaml
let average_temperature reports =
  if reports.num_of_days = 0.0 
    then 0.0
  else
    let total_temp =
      List.fold_left (fun sum day -> sum +. day.temperature) 0.0 reports.days
    in total_temp /. reports.num_of_days;;
```
</details>

### Variant Types

Let's build a custom binary `tree` data type in OCaml! First, we will define the `tree` type:

```ocaml
type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree
```

This recursively defines a `tree` to either be a:

- `Leaf`
- `Node` with a left sub-`tree`, a value, and a right sub-`tree`

#### `tree_add x tree`

- **Type**: `int -> int tree -> int tree`
- **Description**: Given an `int tree`, return a new `int tree` with the same values in the old tree incremented by `x`.
- **Examples**:

  ```ocaml
  let tree_a = Node(Node(Leaf, 5, Leaf), 6, Leaf)
  let tree_b = Node(Node(Leaf, 4, Leaf), 5, Node(Leaf, 2, Leaf))

  tree_add 1 tree_a = Node(Node(Leaf, 6, Leaf), 7, Leaf)
  tree_add 5 tree_b = Node(Node(Leaf, 9, Leaf), 10, Node(Leaf, 7, Leaf))
  ```

<details>
  <summary>Solution!</summary>
  
```ocaml
let rec tree_add x tree = match tree with
  | Leaf -> Leaf
  | Node(l, v, r) -> Node(tree_add x l, v + x, tree_add x r)
```
</details>

#### `tree_preorder tree`

- **Type**: `string tree -> string`
- **Description**: Given a `string tree`, return the preorder concatenation of all the strings in the tree.
- **Examples**:

  ```ocaml
  let tree_c = Node(Node(Leaf, " World", Leaf), "Hello", Node(Leaf, "!", Leaf))
  let tree_d = Node(Node(Node(Leaf, " super", Leaf), " is", Node(Leaf, " easy!", Leaf)), "Recursion", Node(Leaf, " 💀", Leaf))

  tree_preorder tree_c = "Hello World!"
  tree_preorder tree_d = "Recursion is super easy! 💀"
  ```
  
<details>
  <summary>Solution!</summary>
  
```ocaml
let rec tree_add x tree = match tree with
  | Leaf -> Leaf
  | Node(l, v, r) -> Node(tree_add x l, v + x, tree_add x r)
```
</details>

#### `tree_sum_product tree`

- **Type**: `int tree -> int * int`
- **Description**: Given an `int tree`, return an `int * int` tuple of the following form:
  - The first element is the **sum** of **all** numbers in the tree
  - The second element is the **product** of **all** numbers in the tree
- **Examples**:

  ```ocaml
  let tree_a = Node(Node(Leaf, 5, Leaf), 6, Leaf)
  let tree_b = Node(Node(Leaf, 4, Leaf), 5, Node(Leaf, 2, Leaf))

  tree_sum_product tree_a = (11, 30)
  tree_sum_product tree_b = (11, 40)
  ```

<details>
  <summary>Solution!</summary>
  
```ocaml
let rec tree_sum_product tree = 
  match tree with
  | Leaf -> (0, 1)
  | Node(l, v, r) -> 
    let (lsum, lproduct) = tree_sum_product l in
    let (rsum, rproduct) = tree_sum_product r in
    (lsum + v + rsum, lproduct * v * rproduct)
```
</details>

## Resources & Additional Readings

- [Spring 2023 OCaml HOF discussion](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d4_hof)
- [Spring 2023 Project Review](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d5_project_review)
- [Fall 2023 OCaml HOF discussion](https://github.com/cmsc330fall23/cmsc330fall23/tree/main/discussions/d6_ocaml_hof)
- [Fall 2023 Python HOF + Regex discussion](https://github.com/cmsc330fall23/cmsc330fall23/tree/main/discussions/d2_hof_regex)
- [Anwar's Imperative OCaml Slides](https://bakalian.cs.umd.edu/assets/slides/10-imperative.pdf)
