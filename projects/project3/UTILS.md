# `Utils` Module

This is a module of functions you might find useful for implementing the bulk of this project. We have provided these functions in `src/utils.ml`, so you do not need to worry about implementing these. 

> [!CAUTION]
> **DO NOT TOUCH `utils.ml`**. We use our own copy and you **WILL** fail tests if you use modified versions of functions in this module.

# Common Set Functions

These are functions that model common set operations. Feel free to use these throughout the project.

## `elem x a`

- Type: `'a -> 'a list -> bool`
- Description: Returns true iff `x` is an element of the set `a`.
- Examples:
```ocaml
elem 2 [] = false
elem 3 (insert 5 (insert 3 (insert 2 []))) = true
elem 4 (insert 3 (insert 2 (insert 5 []))) = false
```

## `insert x a`

- Type: `'a -> 'a list -> 'a list`
- Description: Inserts `x` into the set `a`.
- Examples:
```ocaml
insert 2 [] = [2]
insert 3 (insert 2 []) = [3; 2]
insert 3 (insert 3 (insert 2 [])) = [3; 2]
```

## `insert_all xs a`

- Type: `'a list -> 'a list -> 'a list`
- Description: Inserts each element from `xs` into the set `a`.
- Examples:
```ocaml
insert_all [2; 3; 3] [] = [2; 3]
insert_all [1; 2; 3] [4; 5; 6] = [1; 2; 3; 4; 5; 6]
```

## `subset a b`

- Type: `'a list -> 'a list -> bool`
- Description: Return true iff `a` **is a** subset of `b`. Formally, A ⊆ B ⇔ ∀x(xϵA ⇒ xϵB).
- Examples:
```ocaml
subset (insert 2 (insert 4 [])) [] = false
subset (insert 5 (insert 3 [])) (insert 3 (insert 5 (insert 2 []))) = true
subset (insert 5 (insert 3 (insert 2 []))) (insert 5 (insert 3 [])) = false
```

## `eq a b`

- Type: `'a list -> 'a list -> bool`
- Description: Returns true iff `a` and `b` are equal as sets. Formally, A = B ⇔ ∀x(xϵA ⇔ xϵB). (Hint: The subset relation is anti-symmetric.)
- Examples:
```ocaml
eq [] (insert 2 []) = false
eq (insert 2 (insert 3 [])) (insert 3 []) = false
eq (insert 3 (insert 2 [])) (insert 2 (insert 3 [])) = true
```

## `remove x a`

- Type: `'a -> 'a list -> 'a list`
- Description: Removes `x` from the set `a`.
- Examples:
```ocaml
elem 3 (remove 3 (insert 2 (insert 3 []))) = false
eq (remove 3 (insert 5 (insert 3 []))) (insert 5 []) = true
```

## `diff a b`

- Type: `'a list -> 'a list -> 'a list`
- Description: Subtracts the set `b` from the set `a`.
- Examples:
```ocaml
diff [1; 2; 3] [1; 2; 3] = []
diff [1; 2; 3] [1; 4; 5] = [2; 3]
diff [1; 2; 3] [4; 5; 6] = [1; 2; 3]
```

## `union a b`

- Type: `'a list -> 'a list -> 'a list`
- Description: Returns the union of the sets `a` and `b`. Formally, A ∪ B = {x | xϵA ∨ xϵB}.
- Examples:
```ocaml
eq (union [] (insert 2 (insert 3 []))) (insert 3 (insert 2 [])) = true
eq (union (insert 5 (insert 2 [])) (insert 2 (insert 3 []))) (insert 3 (insert 2 (insert 5 []))) = true
eq (union (insert 2 (insert 7 [])) (insert 5 [])) (insert 5 (insert 7 (insert 2 []))) = true
```

## `intersection a b`

- Type: `'a list -> 'a list -> 'a list`
- Description: Returns the intersection of sets `a` and `b`. Formally, A ∩ B = {x | xϵA ∧ xϵB}.
- Examples:
```ocaml
eq (intersection (insert 3 (insert 5 (insert 2 []))) []) [] = true
eq (intersection (insert 5 (insert 7 (insert 3 (insert 2 [])))) (insert 6 (insert 4 []))) [] = true
eq (intersection (insert 5 (insert 2 [])) (insert 4 (insert 3 (insert 5 [])))) (insert 5 []) = true
```

## `cat x a`

- Type: `'a -> 'b list -> ('a * 'b) list`
- Description: Turns each element of `a` into a 2-tuple where the first element is `x`.
- Examples:
```ocaml
cat 1 [2; 3; 4] = [(1,2); (1,3); (1,4)]
cat 3 [] = []
cat "hi" [1; 2] = [("hi", 1); ("hi", 2)]
```

## `product a b`

- Type: `'a list -> 'b list -> ('a * 'b) list`
- Description: Cartesian Product. Creates a set of all ordered pairs of the form`(x * y)`, where `x` is from set `a`, and `y` is from set `b`. Formally, A × B = {(a, b) | a ∈ A, b ∈ B}
- Examples:
```ocaml
product [] [] = []
product [1;2] [3;4] = [(1, 3); (1, 4); (2, 3); (2; 4)]
```

# Utility Functions

These are functions we provide as helpers. You may use them as you please and they may make implementing certain functions easier.

### `explode s`

- **Type**: `string -> char list`
- **Description**: This function takes a string and converts it into a character list.
> [!TIP]
> This function may be helpful when implementing `accept`.

### `fresh`

- **Type**: `unit -> int`
- **Description**: This function takes in type `unit` as an argument (similar to Null). This function uses imperative OCaml to return an `int` value that has not been used before by using a reference to a counter.
> [!TIP]
> This function may be helpful when implementing `regexp_to_nfa`.
- **Examples**:

  ```ocaml
  fresh () = 1
  fresh () = 2
  fresh () = 3
  ...
  ```
