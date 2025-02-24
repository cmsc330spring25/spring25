# Project 2: HOFs on trees & Database design
Due: February 24th 11:59 PM (Late: February 25th 11:59 PM)

Points: 40% public, 30% semipublic, 30% secret

**This is an individual assignment. You must work on this project alone.**

## Introduction
The goal of this project is to increase your familiarity with programming in OCaml and give you more practice with higher order functions and user-defined types. You will write a number of small functions that will use higher order functions operating over a tree structure, and then you will implement a program that simulates a database.

### Ground Rules
In addition to your own code, you may use library functions found in the [`Stdlib` module](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html) and the `List` module. You **may not** (under threat of a grading penalty) use any other submodules of `Stdlib` or any imperative features of Ocaml unless otherwise stated. You **may not** make any function in part 2 recursive unless the function already has the `rec` keyword.

### Testing & Submitting
Submit by running `submit` after pushing your code to GitHub. 

To test locally, run `dune runtest -f`. Besides the provided public tests, you will also find the file `student.ml` in `test/student/`, where you'll be able to add `OUnit` tests of your own. More detailed information about writing tests can be found [here](https://www.youtube.com/watch?v=C36JnAcClOQ).

> [!CAUTION]
> Tests for `insert` & `remove` **WILL FAIL** unless `query` is implemented as well.
> In addition, tests **will not run** unless you have defined `db`, `newDatabase`, and `insert`.

You can interactively test your code by running `dune utop src`, which will include your source files. (As usual, all of your commands in `utop` need to end with two semicolons (`;;`), otherwise it will appear as if your terminal is hanging).

> [!TIP]
> If you are using `utop` to test your `db`, and you've already defined your `db` type in your `.ml` file, you can update the contents of the `.mli` file to include your type definition so that it doesn't show up as `<abstr>` when `utop` shows the value of a `db`.

### Check Out Link:
- Please readme in its entirety before posting on piazza.
- Please read the pinned project2 FAQ post on piazza before posting on piazza.
- [https://classroom.github.com/a/fRfqs-D-](https://classroom.github.com/a/fRfqs-D-)

## Part 1: Database Design

Create a program that stores `person`s in a database which can later be queried. 
A person is defined as follows:

```ocaml
type person = { name: string;
                age: int;
                hobbies: string list }
```

You must come up with your own implementation for the data type for the database `db`. As provided above, `person` includes `name`, `age`, and `hobbies`, which is the data we would like to add to our database.

Given a piece of data like `person`, you will implement the following operations on the database:

### `newDatabase`
  - **Type**: `db`
  - **Description**: creates and returns an empty database

### `insert person database`: 
  - **Type**: `person -> db -> db`
  - **Description**: given a person and a database, insert the person into the database and return the updated database. If the person already exists in the database, there should be duplicate entries of the person after performing the insert function.
  - **Examples**:
  ```ocaml
  let db1 = insert {name="Alice"; age=23; hobbies=["Skiing";"golfing"]} newDatabase
  let db1 = insert {name="Alice"; age=23; hobbies=["Skiing";"golfing"]} db1
  (* db1 stores a database that includes Alice twice, so querying the size
      of this database should result in 2 instances of the Alice person *)
  ```

### `remove name database`: 
  - **Type**: `string -> db -> db`
  - **Description**: given a person's name and a database, remove all persons with the same name from the database and return the updated database. If no persons exist in the database with the same name as the given person, the database should not change.
  - **Examples**:
  ```ocaml
  let db1 = remove "Alice" db1
  (* db1 no longer contains Alice, db1 is now empty *)
  ```
#### Comparator
A comparator is a function that tells how to compare two people. It will be used in the `sort` function.
Its type is `person -> person -> int`. It follows the typical -1, 0, 1 convention. Below is an example comparator:
  ```ocaml
  let comparator1 p1 p2 = 
    if p1.age < p2.age then -1
    else if p1.age = p2.age then 0
    else 1
  ```

### `sort comparator db`:
  - **Type**: `(person -> person -> int) -> db -> person list`
  - **Description**: given a comparator function and a db, sort the list of people based on the comparator and return in the form of a person list. You may use anything from the `Stdlib` or the `List` modules to help you.
   - **Examples**:
  ```ocaml
  let db1 = insert {name="Alice"; age=23; hobbies=["Skiing"; "golfing"]} newDatabase

  let db2 = insert {name="Bob"; age=42; hobbies=["Skiing"; "Cooking"; "Legos"]} db1

  sort comparator1 db2 = [{name="Alice"; age=23; hobbies=["Skiing"; "golfing"]}; {name="Bob"; age=42; hobbies=["Skiing"; "Cooking"; "Legos"]}]
  ```

#### Aside

When we are describing something we typically link together and modify different 
descriptors with common words like *and*, *or*, *not*. For example: "His name 
is Cliff AND he is older than 18 AND (he likes Lego OR he likes chocolate)." 
The parentheses are added to remove ambiguity. By defining words
like *and* and *or* to link exactly 2 parts, we can figure out exactly which 
parts are under the *and* condition and which are under the *or* condition. 
Visually this looks like:
```text
and(e1,e2)
or(e1,e2)

and(name is cliff,and(older than 18, or(likes Lego, likes Chocolate)))
```

The nice part about this modified English grammar/syntax is that we don't have 
ambiguity and it's easy to represent this as code. See below.

#### Condition
A `condition` is a restriction on the combination of age, name, and/or hobbies. We represent a condition as a type containing either a true/false value, a restriction on age, name, or hobbies, or a logical operator that contains other conditions. The `condition` type will look like this:
```ocaml
type condition = 
  | True
  | False
  | Age of (int -> bool)
  | Name of (string -> bool)
  | Hobbies of (string list-> bool)
  | And of condition * condition
  | Or of condition * condition
  | Not of condition
  | If of condition * condition * condition
```

Assume that conditions assigned to `True` will always evaluate to `true` and `False` will evaluate to `false`. For example, if I wanted to get a list of people who are over 30 **and** have the name "Bob", our condition would look like this:
```ocaml
  let condition1 = And(Age(fun age -> age > 30), Name(fun name -> name = "Bob"));;
```
Other examples of valid `condition`s are:
```ocaml
  False

  Name(fun name -> name = "Alice")

  Not((Age(fun age -> a < 30)))

  If(True,Age(fun age -> a < 30),Name(fun name -> name = "Bob"))
  (* if true then Age else Name *)

  Or(True,Hobbies(fun hobbies -> false))
```


### `query condition db`:
  - **Type**: `condition -> db -> person list`
 - **Description**: given a condition and a database, return a list of all entries in the database that satisfy the condition.
 - **Examples**:
  ```ocaml
  let db1 = insert {name="Alice"; age=23; hobbies=["Skiing"; "golfing"]} newDatabase
  let db2 = insert {name="Bob"; age=42; hobbies=["Skiing"; "Cooking"; "Legos"]} db1

  query condition1 db2 = [{name="Bob";age=42;hobbies=["Skiing";"Cooking"; "Legos"]}]
  query True db2 = [{name="Bob";age=42;hobbies=["Skiing";"Cooking";"Legos"]}; {name="Alice";age=23;hobbies=["Skiing";"golfing"]}]
(* querying with condition True returns a person list that contains all people in the db *)
  query False db2 = []
  ```
   
### `queryBy condition database comparator`:
   - **Type**: `condition -> db -> comparator -> person list`:
   - **Description**: given a condition, a database, and a comparator, return a list of all entries in the database that satisfy that query that is sorted by the comparator function
   - **Examples**:
   ```ocaml
   let comparator1 p1 p2 = 
    if p1.age < p2.age then -1
    else if p1.age == p2.age then 0
    else 1

   condition2 = Age(fun age -> age < 90)

   queryBy condition2 db2 comparator1 = [{name="Alice";age=23;hobbies=["Skiing";"golfing"]}; {name="Bob";age=42;hobbies=["Skiing";"Cooking"; "Legos"]}]
   ```

### `update condition db personData`
  - **Type**: `condition -> db -> (person -> person) -> db`  
  - **Description**: given a condition, a database, and a function that will return a person with updated data given a person, update every person in the database that satisfies the provided condition
  - **Examples**: 
  ```ocaml
  let change1 = fun person -> { name = person.name; age = person.age; hobbies = "Pickleball"::person.hobbies}

  let updated = update condition1 db2 change1
  query True updated = [{name="Bob";age=42;hobbies=["Pickleball";"Skiing";"Cooking"; "Legos"]}; {name="Alice";age=23;hobbies=["Skiing";"golfing"]}]
  (* Bob's hobbies are now updated to include pickleball *)
  ```

### `deleteAll condition db`
  - **Type**: `condition -> db -> db` 
  - **Description**: given a condition and a database, delete all entries
   in the database that satisfy the query
  - **Examples**: 
  ```ocaml
  deleteAll condition1 db2
  (* Bob is deleted from our database *)
  ```

## Part 2: Higher Order Functions On Trees

***This part is independent of Part 1***

Given the type of a binary tree, implement `fold` and `map` operations.

```ocaml
type 'a tree =
  | Node of 'a tree * 'a * 'a tree
  | Leaf

```

Given this type implement the following functions

### `tree_fold f init tree` 
  - **Type**: `(('a -> 'b -> 'a -> 'a) -> 'a -> 'b tree -> 'a)`
  - **Description**: Given a function `f`, accumulator `init`, and `tree`, iterate over the given tree using `f` and return the iterated value of type `'a`. 
  The function `f` will take in three parameters: the value of the accumulator returned by the left branch of the node, the value of the current node, and the value of the accumulator returned by the right branch of the node, and should then return the new accumulated value of type `'a`.

  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, "Hello", Leaf), " World", Node(Leaf, "!", Leaf)) in
  let treeb = Node(Node(Leaf, 5, Leaf), 6, Leaf) in
  
  tree_fold (fun l s r -> l ^ s ^ r) "" treea = "Hello World!"
  tree_fold (fun l x r -> max (max l x) r) 0 treeb = 6
  ```
   
### `map tree f`
  - **Type**: `('a tree -> ('a -> 'b) -> 'b tree)`
  - **Description**: Given a function `f`, map all the values of the nodes in the tree using `f`. You must implement this function using `tree_fold`.
  Note that the mapped tree should still return the same tree shape with the corresponding mapped nodes.
  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 2, Leaf)) in
  let treeb = Node(Node(Leaf, 1, Leaf), 2, Node(Node(Leaf, 3, Leaf), 4, Leaf)) in
  
  map treea string_of_int = Node(Node(Leaf, "1", Leaf), "2", Node(Leaf, "2", Leaf))
  map treeb (fun x -> x + 1) = Node(Node(Leaf, 2, Leaf), 3, Node(Node(Leaf, 4, Leaf), 5, Leaf)) 
  ```
 
### `mirror tree`
  - **Type**: `('a tree -> 'a tree)`
  - **Description**: Write a function using `tree_fold` that will return the given tree with the left and right branches swapped at each node.
  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf))
  let treeb = Node(Node(Leaf, 1, Leaf), 2, Node(Node(Leaf, 3, Leaf), 4, Leaf))
  
  mirror treea = Node(Node(Leaf, 3, Leaf), 2, Node(Leaf, 1, Leaf));
  mirror treeb = Node(Node(Leaf, 4, Node(Leaf, 3, Leaf)), 2, Node(Leaf, 1, Leaf))
  ```
   
### `in_order tree`
  - **Type**: `('a tree -> 'a list)`
  - **Description**: Using `tree_fold`, write a function that will return a list containing the inorder traversal of the tree.
  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf))
  let treeb = Node(Node(Leaf, 1, Leaf), 2, Node(Node(Leaf, 3, Leaf), 4, Leaf))
  
  in_order treea = [1; 2; 3]
  in_order treeb = [1; 2; 3; 4]
  ```

### `pre_order tree`
  - **Type**: `('a tree -> 'a list)`
  - **Description**: Using `tree_fold`, write a function that will return a list containing the preorder traversal of the tree.
  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf))
  let treeb = Node(Node(Leaf, 1, Leaf), 2, Node(Node(Leaf, 3, Leaf), 4, Leaf))
  
  pre_order treea = [2; 1; 3]
  pre_order treeb = [2; 1; 4; 3]
  ```
   
### `compose tree`
  - **Type**: `(('a -> 'a) tree -> 'a -> 'a)`
  - **Description**: This function will take in a tree that contains `('a -> 'a)` functions as the value in the nodes and returns a function that is the *inorder* composition of the nodes. You must implement this function using `tree_fold`.
  - **Examples**:
  Consider the following diagram of a tree.
```  
                  +------+
          +-------+ f(x) +-------+
          |       +------+       |
          |                      |
       +--+---+              +---+--+
   +---+ g(x) |          +---+ h(x) |
   |   +------+          |   +------+
   |                     |
+--+---+              +--+---+
| v(x) |              | y(x) |
+------+              +------+
```
  The result of calling `compose` on this function would be equivalent to `(fun x -> h (y (f (g (v x)))))`
  ```ocaml
  let function_tree =
    Node(
        Node(Leaf, (fun x -> x+1), Leaf),
        (fun x -> x*x),
        Node(Leaf, (fun x -> -x +x*x), Leaf))

  let composed = compose function_tree
    composed 0 = 0
    composed 1 = 12

  let composed2 = compose Leaf
    composed2 2 = 2
    composed2 15 = 15
  ```

### `depth tree`
  - **Type**: `('a tree -> int)`
  - **Description**: Using `tree_fold` write a function that returns the depth of the deepest node in the tree.
  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf)) in
  let treeb = Node(Node(Leaf, 1, Leaf), 2, Node(Node(Leaf, 3, Leaf), 4, Leaf)) in

  depth treea = 2
  depth treeb = 3
  depth Leaf = 0
  ```
   
### `trim tree n`
  - **Type**: `('a tree -> int -> 'a tree)`
  - **Description**: Using `tree_fold` write a function that takes in a **perfect** binary tree `tree` and an integer `n`, and trims off nodes at the bottom of the tree such that the depth of the returned tree is at most n.
  - **Examples**:
  ```ocaml
  let tree = Node(Node(Node(Leaf, 4, Leaf), 2, Node(Leaf, 4, Leaf)), 1, Node(Node(Leaf, 4, Leaf), 2, Node(Leaf, 4, Leaf))) in

  trim tree 1 = Node(Leaf, 1, Leaf);
  trim tree 2 = Node(Node(Leaf, 2, Leaf), 1, Node(Leaf, 2, Leaf))
  ```
## Part 3: Generating Trees
#### Options
An `option` type is a built in variant that indicates the presence or absence of a value of type `'a`: 
  ```ocaml
  type 'a option = 
  | None
  | Some of 'a
  ```

##### Notes: The functions **`tree_init`** and **`split`** are **optional** and will not be tested on, but are recommended helper functions for `from_pre_in`.
#### To avoid failing restriction check, define any additional recursive helper functions inside of the functions they are called in 
### `tree_init f v`
  - **Type**: `('a -> ('a * 'b * 'a) option) -> 'a -> 'b tree)`
  - **Description**: A generator `f` is a function that returns a tuple of 3 values: (`v1`, `v2`, `v3`). Using the definition of type `Option`, `f`, and an init value `v`, build a tree that has a root node with value `v2` and a new generated left subtree with init value `v1` and a new generated right subtree with init `v3`.
  If `f` returns `None`, a `Leaf` will be placed into the tree.
  - **Examples**:
  ```ocaml
  let generator1 a =
    if a <= 3 then
	  Some (a+1, a, a+1)
    else None
	
  let generator2 a =
    if a <= 3 then
	  Some (a+1, a, a+2)
    else None
	
  tree_init generator1 1 = Node(Node(Node(Leaf, 3, Leaf), 2, Node(Leaf, 3, Leaf)), 1, Node(Node(Leaf, 3, Leaf), 2, Node(Leaf, 3, Leaf)))
  tree_init generator2 1 = Node(Node(Node(Leaf, 3, Leaf), 2, Leaf), 1, Node(Leaf, 3, Leaf))
  ```

### `split lst v`
  - **Type**: `'a list -> 'a -> 'a list * 'a list`
  - **Description**: Given a list `lst` find the first instance of `v` in the list, and return a tuple of lists where the first list in the tuple is all the elements that come before `v` in `lst` and the second element contains all the elements that come after `v` in `lst`
  - **Examples**:
  ```ocaml
  split [1; 2; 3; 4] 2 = ([1], [3; 4])
  split ["Hello"; "World"] "World" = (["Hello"], [])
  ```
   
### `from_pre_in pre in_ord`
  - **Type**: `('a list -> 'a list -> 'a tree)`
  - **Description**: Given a list containing the pre-order traversal of a tree `pre` and a list containing the in-order traversal of a tree `in_ord`, create a tree that corresponds to the two traversals. Assume there will be no duplicate nodes in the tree. You may use the algorithm described [here](./from_pre_in.pdf) to implement this function. ***Hint: You can use `tree_init` and `split` in this function***
  - **Examples**:
  ```ocaml
  let treea = Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf))
  let treeb = Node(Node(Leaf, 1, Leaf), 2, Node(Node(Leaf, 3, Leaf), 4, Leaf));;

  from_pre_in [2; 1; 3] [1; 2; 3] = treea;
  from_pre_in [2; 1; 4; 3] [1; 2; 3; 4] = treeb
  ```

