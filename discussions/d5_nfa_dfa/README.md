# Discussion 5 - Friday, February 28th

## Reminders
1. **Quiz 2 Today!**
   1. You will have 25 minutes to complete it
1. **Exam 1 Next Thursday! (3/6)**
   1. Takes place during lecture, topics list on Piazza
3. Office Hours Reminders:
   1. Be respectful to TAs
   2. Do not camp out in OH space
1. Academic Dishonesty Reminder:
   1. Do not share code or discuss implementation details
   2. Academic dishonesty can result in getting an XF in the class

## Notes

### Key differences between NFA and DFA

- All DFAs are NFAs, but not all NFAs are DFAs.
- NFA can have ε-transition(s) between states.
- NFA states can have multiple transitions going out of them using the same symbol.
- DFAs are computationally cheaper to process, but often harder to read compared to NFAs.

### Conversion Algorithm

Input: $\text{NFA}(\Sigma, Q, q_0, F_n, \delta)$ \
Output: $\text{DFA}(\Sigma, R, r_0, F_d, \delta')$ \
Let $r_0$ = $\varepsilon\text{-closure}(\delta, q_0)$, add it to $R$\
While $\exists$ an unmarked state $r \in R$:\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mark $r$\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For each $\sigma \in \Sigma$\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $E = \text{move}(\delta, r, \sigma)$\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $e = \varepsilon\text{-closure}(\delta, E)$\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If $e \notin R$\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $R = R \cup \\{e\\}$\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Let $\delta' = \delta' \cup \\{ r, \sigma, e \\} $\
Let $F = \\{r \mid \exists s \in r \text{ with } s \in F_n \\}$

## Exercises

### NFA -> DFA

1. Trace through the NFA -> DFA conversion algorithm using the table method for the following NFAs:

a) ![image](https://hackmd.io/_uploads/Bke1Ucw9yl.png)
b) ![image](https://hackmd.io/_uploads/ryMxLqPqye.png)
c) ![image](https://hackmd.io/_uploads/HJMbI9D5Je.png)
d) ![image](https://hackmd.io/_uploads/H1cZ8qP5kg.png)

<details>
  <summary>Solutions!</summary>

a) ![image](https://hackmd.io/_uploads/rkow89P9yl.png)
b) ![image](https://hackmd.io/_uploads/By3sIqwqkx.png)
c) ![image](https://hackmd.io/_uploads/BkB389vqJx.png)
d) ![image](https://hackmd.io/_uploads/HyQbPqP91x.png)
    
</details>

### Regex -> NFA -> DFA

2. Consider the following regular expressions:

   ```re
   a) a*b?
   b) (b|c)+
   c) a*b?(b|c)+
   ```

   - Convert each regex to an equivalent NFA
     - Note that there are many valid NFAs
   - Convert each NFA to its equivalent DFA
   - Compare your DFA with the person next to you
     - Are they the same?

<details>
  <summary>Solutions!</summary>

a) ![image](https://hackmd.io/_uploads/HykXPqvqye.png)
b) ![image](https://hackmd.io/_uploads/H1CXPqvcke.png)
c) ![image](https://hackmd.io/_uploads/B1sNDqwq1g.png)
    
</details>

## Resources & Additional Readings

- [Fall 2023 Discussion - NFA and DFA](https://github.com/cmsc330fall23/cmsc330fall23/tree/main/discussions/d3_nfa_dfa)
- [Fall 2023 Discussion - NFA and DFA Conversion](https://github.com/cmsc330fall23/cmsc330fall23/tree/main/discussions/d4_nfa_dfa_conversion)
- [Spring 2023 Discussion - NFA and DFA](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d6_nfa_dfa)
- [Slides - NFA to DFA Conversion](https://bakalian.cs.umd.edu/assets/slides/14-automata3.pdf)
