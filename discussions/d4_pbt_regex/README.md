# Discussion 4 - Friday, February 21st

## Reminders

1. Quiz 2 next **Friday, February 28th**!
   - [Quiz 2 Logistics](https://piazza.com/class/m6687mvdhig1iw/post/561)
3. Project 2 released, due **Monday, February 24 @ 11:59 PM**

## Topic List

- Imperative OCaml
- Property-Based Testing
- Regular Expressions

## Review - Imperative OCaml

```ocaml
# let z = 3;;
  val z : int = 3
# let x = ref z;;
  val x : int ref = {contents = 3}
# let y = x;;
  val y : int ref = {contents = 3}
```
Here, `z` is bound to 3. It is immutable.  `x` and `y` are bound to a reference. The `contents` of the reference is mutable. 
```ocaml
x := 4;;
```
will update the `contents` to 4. `x` and `y` now point to the value 4. 
```ocaml
!y;;
  - : int = 4
```
Here, variables y and x are aliases. In `let y = x`, variable `x` evaluates to a location, and `y` is bound to the same location. So, changing the contents of that location will cause both `!x` and `!y` to change.

## Exercises

### Imperative OCaml Counter

**Recall:** The `unit` type means that no input parameters are required for the function.

Implement a counter called `counter`, which keeps track of a value starting at 0. Then, write a function called `next: unit -> int`, which returns a new integer every time it is called.

#### Example
```ocaml
(* First call of next () *)
# next ();;
 : int = 1

(* First call of next () *)
# next ();;
 : int = 2
```

#### Solution:
<details>
  <summary><b>Click here!</b></summary>
  
```ocaml
# let counter = ref 0 ;;
val counter : int ref = { contents=0 }

# let next = 
    fun () -> counter := !counter + 1; !counter ;;
val next : unit -> int = <fun>
```
</details>

### Function argument evaluation order 

What happens when we run this code?
```ocaml
let x = ref 0;;
let f _ r = r;;
f (x:=2) (!x)
```
#### Solution:
<details>
  <summary><b>Click here!</b></summary>
Ocaml's order of argument evaluation is not defined. On some systems it's left to right on others it's right to left.
    
On my system, <b>f</b> evaluates to <b>0</b>, but on your system it may evaluate to <b>2</b>!   
</details>

## Property-Based Testing

Why do we even care about property-based testing and what do we need to know about them?

Suppose you write a function `square` to calculate the square of a number.

```ocaml
let square x = (* square an integer*)
```

Now you want to test whether your implementation is correct. One way to go about this is creating unit tests

```ocaml
square 3 = 9
square 4 = 16
square (-1) = 1
```

Writing unit tests can get tedious, though. This is where property-based testing comes in; the purpose of PBTs is to test whether some property of a function behaves as expected, *independent of input*. Now, where can PBTs go wrong?

Consider the following attempt at a property-based test for a `length` function:

```ocaml
let length lst = (* calculate length of a list *)

let delete x lst = (* return a list without x *)

length(delete x lst) < length lst 
```

This property says that if you delete an item from a list, the size of the list should be smaller than when it started. This sounds right, but *is false if the item to be deleted was not actually in the list*. In this case, the list size stays the same so this is not a valid property.

**So we can ask: given a property $p$, is $p$ actually valid?**


Now suppose we have a valid property. For example, we know that reversing a list twice should return the original list, for any list. If we translated this into code as:

```ocaml
let rev lst = (*reverse a list*)
rev (lst) = lst
```
then we did not accurately translate the property, since this code doesn't actually do what we want!

**So we can ask: given a property $p$ and a function $f$ encoding $p$, does $f$ actually represent $p$?**

Finally, while the property could be valid, and while the property we write could be a correct encoding, it is possible the property does not catch bugs in our code. Consider the following:

```ocaml
rev (rev lst) = lst
```
This is clearly a valid property from our discussion earlier, and a valid encoding of the property. However, imagine we wrote `rev` like

```ocaml
let rev lst = lst
```
Then this property will not actually detect the bug in my code (namely the fact that `rev` is completely incorrect).\
This shows the importance of combining multiple properties + unit tests for ensuring program correctness.

**So we can ask, given a valid property $p$, and a buggy implementation of this function $f$, will the property $p$ catch any bugs in $f$?**

## Exercises - Property-Based Testing

1. Consider the following linked list type:
    ```ocaml
    type 'a linked = Node of 'a * 'a linked | Nil
    ```
    and the following function that is supposed to insert the element `x` after each instance of `targ`:
    ```ocaml
    let rec insert_x lst targ x = match lst with
       | Nil -> Nil
       | Node(ele, rest) -> if ele = targ then Node(x, insert_x rest targ x) else insert_x rest targ x
    ```
    Next, consider the property:
    > The result of running `insert_x` on any `linked` type will always have a length greater or equal to that of the original list.
    
    and it's implementation (assuming the `length` function is valid for `linked` types):
    ```ocaml
    let test_prop lst = length insert_x lst input1 input2 >= length lst
    ```
    - Is the property valid?
        #### Solution:
        <details>
        <summary><b>Click here!</b></summary>
        Yes, all elements of the original list are all preserved.
        </details>
    - Is `test_prop` a valid encoding of the property?
        #### Solution:
        <details>
        <summary><b>Click here!</b></summary>
        Yes, accurately compares the length of list with the function applied and without.
        </details>
    - If we test this property on the provided implementation of `insert_x`, will it always assert true?
        #### Solution:
        <details>
        <summary><b>Click here!</b></summary>
        No, the second match case has an error. It should be:
            
        ```ocaml
        if ele = targ then Node(ele, Node(x, insert_x rest targ x) else Node(ele, insert_x rest targ x)
        ```
            
        The current implementation fails to re-add the current element, resulting in a list of just `x`s that has length of the amount of `targ` (less than the original list):
            
        ```ocaml
        let ll = Node(3, 
                  Node(4, 
                   Node(5,
                    Node(3, 
                     Node(7, 
                      Node(3, 
                       Node(10, 
                        Nil
                      ))))))) in
        insert_x ll 3 11 (* evals to  Node(11, Node (11, Node (11, Nil))) *)
        ```
            
        </details>
    
2. From Spring 2024 final:
![image](https://hackmd.io/_uploads/H1BVzVqaC.png)

    #### Solution:
    <details>
      <summary><b>Click here!</b></summary>

    ```
    1: not valid property, na, valid property function

    2: valid property, will catch bugs, valid property function
    ```
    </details>


## Review - Regular Expressions
There are many patterns regex can describe aside from string literals.

- **Concatenation (and)**: `ab` We use this to accept something that satisfies a and b in that order, where a and b can denote sub-regex.
    - Ex. `a` matches "a", `b` matches "b", so `ab` matches "ab"
    - Ex. `(a|b)` matches "a" or "b", `c` matches "c", so `(a|b)c` matches "ac" or "bc"
- **Union (or)**: `a|b|c` We use this to accept something from given choices. **Note** that a, b, or c can also denote sub-regex if parentheses are specified.
    - Ex. `a|b|c` matches "a" or "b" or "c"
- **Precedence (parentheses)**: `(a)` are used to enforce order of evaluation and capture groups.
    - Ex. `a|bc` matches "a" or "bc". This is the same as `a|(bc)`
    - Ex. `(a|b)c` matches "ac" or "bc"
- **Sets**: `[abc]` We use this to accept one character from the given choices.
    - Ex. `[abc]` matches "a" or "b" or "c"
- **Ranges**: `[a-z]`, `[c-k]`, `[A-Z]`, `[0-9]` We use these ranges, also known as character classes, to accept characters within a specified range (inclusive).
    - Ex. `[a-z]` matches any lowercase letter
    - Ex. `[c-k]` matches letters c to k inclusive
    - Ex. `[A-Z]` matches any uppercase letter
    - Ex. `[0-9]` matches any digit
    - Ex. `[a-z0-9]` matches any lowercase letter or digit
- **Negation**: `[^abc]` `[^a-z]` `[^0-9]` We use these to exclude a set of characters.
    - Ex. `[^abc]` matches with any character other than "a", "b", or "c"
    - Ex. `[^a-z]` matches with any character that is not a lowercase letter
    - Ex. `[^0-9]` matches with any character that is not a digit
    - Note that the use of "^" differs from the beginning of a pattern
- **Meta Characters**: `\d`, `\D`, `\s`, `\w`, `\W` We use these characters to match on any of a particular type of pattern.
    - ex. `\d` matches any digit (equivalent to `[0-9]`)
    - ex. `\D` matches any character that is not a digit (equivalent to `[^0-9]`)
    - ex. `\s` matches any whitespace character (spaces, tabs, or newlines)
    - ex. `\w` matches any alphanumeric character from the basic Latin alphabet, including the underscore (equivalent to `[A-Za-z0-9_]`)
    - ex. `\W` matches any character that is not a word character from the basic Latin alphabet (equivalent to `[^A-Za-z0-9_]`)
- **Wildcard**: `.` We use this to match on **any** single character. Note: to use a literal `.`, we must escape it, i.e. `\.`
- **Repetitions**: `a*`, `a+`, `a?`, `a{3}`, `a{4,6}`, `a{4,}`, `a{,4}`:
    - Ex. `a*` matches with 0 or more a's
    - Ex. `a+` matches with at least one a
    - Ex. `a?` matches with 0 or 1 a
    - Ex. `a{3}` matches with exactly three a's
    - Ex. `a{4,6}` matches with 4, 5, or 6 a's
    - Ex. `a{4,}` matches with at least 4 a's
    - Ex. `a{,4}` matches with at most 4 a's
    - **Note**: a can denote a sub-regex
- **Partial Match**: `a` and `abc` These patterns can match any part of a string that contains the specified characters.
    - Ex. `a` matches "a", "ab," "yay," or "apple"
    - Ex. `abc` matches "abc", "abcdefg," "xyzabcjklm," or "abc123"
    - **Note**: They do not require the specified sequence to be at the beginning or end of the string
- **Beginning of a pattern**: `^hello` The string must begin with "hello".
    - Ex. `^hello` matches with "hellocliff" but does not match with "cliffhello"
- **End of a pattern**: `bye$` The string must end with "bye".
    - Ex. `bye$` matches with "cliffbye" but does not match with "byecliff"
- **Exact Match**: `^hello$` The string must be exactly "hello".
    - Ex. `^hello$` only matches "hello" and no other string
    - **Note**: Enforces both the beginning and end of the string

> **Question**: *Can every string pattern be expressed with a regex?*

**Answer**: No!

There are certain string patterns that **cannot** be expressed with regex. This is because regex is memoryless; as they cannot keep track of what they have already seen.

As an example, consider a pattern that represents all palindromes, e.g. "racecar". We can't track how many of each character we have previously seen (assuming our regex engine doesn't have backreferences).

## Exercises - Regular Expressions

Write a regex pattern for each of the following scenarios (or explain why you cannot):

1. **Exactly** matches a string that alternates between capital & lowercase letters, starting with capital letters. Single-character strings with just one capital letter and empty strings should be allowed.
    - Includes: "AaBbCc", "DlFsPrOa", "HiWoRlD"
    - Excludes: "aAbBcC", "aaa", "123"
2. Matches a string that contains an even number of 3s, and then an odd number of 4s.
    - Includes: "3333444", "334", "3333334444444", "4"
    - Excludes: "34", "33344", "334444", "1111222"
3. Matches a string that contains a phone number following the format (XXX)-XXX-XXXX where X represents a digit.
    - Includes: "(123)-456-7890", "(111)-222-3333"
    - Excludes: "123-456-7890", "1234567890"
4. **Exactly** matches a string email following the format [Directory ID]@umd.edu where [Directory ID] is any sequence consisting of lowercase letters (a-z), uppercase letters (A-Z), or digits (0-9) with length >= 1.
    - Includes: "colemak123@umd.edu", "ArStDhNeIo@umd.edu", "b@umd.edu"
    - Excludes: "qwerty@gmail.com", "@umd.edu"
5. Matches a string that has more 7s, 8s, and 9s than 1s, 2s, and 3s.
    - Includes: "7891", "123778899", "12789", "8"
    - Excludes: "1", "271", "12399", "831"

### Solutions


<details>
  <summary><b>Click here!</b></summary>
  
1. `^([A-Z][a-z])*([A-Z])?$`
2. `(33)*4(44)*`
3. `\([0-9]{3}\)-[0-9]{3}-[0-9]{4}` (Note, we have to escape the parenthesis with `\`)
4. `^[a-zA-Z0-9]+@umd\.edu$` (Note, we have to escape the period with `\`)
5. Cannot be represented with regular expressions, since there is no memory of which numbers have been previously used.
  
</details>

## Resources & Additional Readings

- [Fall 2023 Python HOF + Regex discussion](https://github.com/cmsc330fall23/cmsc330fall23/tree/main/discussions/d2_hof_regex)
- [Anwar's Property Based Testing Notes](https://github.com/anwarmamat/cmsc330spring2024/blob/main/pbt.md)
- [Anwar's Imperative OCaml Notes](https://github.com/anwarmamat/cmsc330spring2024/blob/main/imperative.md)
- [Online Regular Expression Tester](https://regexr.com/)
- [Regex Practice Problem Generator](https://apabla1.github.io/)
