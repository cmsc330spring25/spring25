# Discussion 6 - Friday, March 7th

## Reminders

- Project 3 due **Friday, March 14 @ 11:59 PM**
    - Don't wait until the last day, as office hours may change prior to break.
- Spring break from March 15-23!
   
## NFAs and DFAs Review
Know the following:
- Properties of and differences between NFAs and DFAs
- How to convert Regex -> NFA/DFA and DFA/NFA -> Regex
- How to convert an NFA -> DFA using the table method

### More Regex to NFA to DFA
Convert the following regular expressions to an equivalent NFA, and then convert each NFA to its equivalent DFA.
```
a) [a-c]+d{1,2}
b) ab?a|bc*
c) a*(c*b)?
```
### More NFA to DFA practice!
Convert the following NFAs to its equivalent DFA.

![image](https://hackmd.io/_uploads/BkVkM8Gikx.png)

<details>
  <summary>Solutions!</summary>
  
![image](https://hackmd.io/_uploads/BJHcUJHj1x.png)
    
</details>

### DFA to Regex

Take these DFAs and create a regex that accept the same strings:

To do this, remove edges and nodes by creating transitions that involve a regex instead of a character.

#### Simple Example:

![image](https://hackmd.io/_uploads/SkG-5VIiyg.png)

First, we will expand the node here to include a start and end state.

![image](https://hackmd.io/_uploads/Hy5zq48iyg.png)

Then, we will remove the interior node and replace it with a regex that represents the node's accepted strings.

![image](https://hackmd.io/_uploads/S1pt9NIokg.png)

Note that the regex created from this will not be very clean, nor will it be optimal. To see some examples of how complicated it can get, you can look through [Cliff's DFA to Regex Generator](https://bakalian.cs.umd.edu/330/practice/dfa2regex).

For additional resources on converting DFA to Regex, take a look at the last two pages of [Cliff's FSM notes](https://bakalian.cs.umd.edu/assets/notes/fa.pdf).

#### Practice Problems:

1. ![image](https://hackmd.io/_uploads/Byn0iE8sJg.png)

2. ![image](https://hackmd.io/_uploads/rydZa4Ijyx.png)

<details>
  <summary>Solutions!</summary>
  
Note that these are not the only working solutions.
    
The final regex can be assumed from these "simpler" FSM states after conversion.
    
1. ![image](https://hackmd.io/_uploads/S1my2NUi1g.png)

2. ![image](https://hackmd.io/_uploads/HyEGpEUjyg.png)
    
</details>


### Resources and Extra Practice
- [NFA to DFA Practice Problems](https://bakalian.cs.umd.edu/330/practice/nfa2dfa)
- [Fall 2024 Discussion 5](https://github.com/cmsc330fall24/fall2024/blob/main/discussions/d5_nfa_dfa/README.md)
- [Slides - Reducing NFA to DFA](https://bakalian.cs.umd.edu/assets/slides/14-automata3.pdf)
- [NFA to DFA Conversion Examples](https://github.com/anwarmamat/cmsc330spring2024/blob/main/nfa2dfa/nfa2dfa.md)
- [Cliff's FSM notes](https://bakalian.cs.umd.edu/assets/notes/fa.pdf)
