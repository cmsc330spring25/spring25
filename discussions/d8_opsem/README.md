# Discussion 8 - Friday, March 23rd

## Reminders

1. Quiz 3 today at the start of discussion. Students have **25 minutes** to complete the quiz.
2. Project 4 released, due **Thursday, April 3rd @ 11:59pm**.

## Operational Semantics

#### Problem 1:

Using the rules below, show: $\large 1 + (2 + 3) \implies 6$

$\Huge \frac{}{n \implies n} \quad \frac{e_1 \implies n_1 \quad e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{e_1+e_2 \implies n_3}$

#### Problem 2:

Using the rules given below, show: $\large A;\textbf{let}\ y = 1\ \textbf{in}\ \textbf{let}\ x = 2\ \textbf{in}\ x \implies 2$

$\Huge \frac{}{A;\ n \implies n} \quad \frac{A(x)\ =\ v}{A;\ x \implies v} \quad \frac{A;\ e_1 \implies v_1 \quad A,\ x\ :\ v_1;\ e_2 \implies v_2}{A;\ \textbf{let}\ x = e_1\ \textbf{in}\ e_2 \implies v_2} \quad \frac{A;\ e_1 \implies n_1 \quad A;\ e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{A;\ e_1+e_2 \implies n_3}$

#### Problem 3:

Using the rules given below, show: $\large A;\textbf{let}\ x = 3\ \textbf{in}\ \textbf{let}\ x = x + 6 \ \textbf{in}\ x \implies 9$

$\Huge \frac{}{A;\ n \implies n} \quad \frac{A(x)\ =\ v}{A;\ x \implies v} \quad \frac{A;\ e_1 \implies v_1 \quad A,\ x\ :\ v_1;\ e_2 \implies v_2}{A;\ \textbf{let}\ x = e_1\ \textbf{in}\ e_2 \implies v_2} \quad \frac{A;\ e_1 \implies n_1 \quad A;\ e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{A;\ e_1+e_2 \implies n_3}$

#### Problem 4:

**Note:** This problem takes a long time, I recommend completing in your own time!

Using the rules given below, show: $\large A;\textbf{let}\ x = 2\ \textbf{in}\ \textbf{let}\ y = 3\ \textbf{in}\ \textbf{let}\ x = x + 2 \ \textbf{in}\ x + y \implies 7$

$\Huge \frac{}{A;\ n \implies n} \quad \frac{A(x)\ =\ v}{A;\ x \implies v} \quad \frac{A;\ e_1 \implies v_1 \quad A,\ x\ :\ v_1;\ e_2 \implies v_2}{A;\ \textbf{let}\ x = e_1\ \textbf{in}\ e_2 \implies v_2} \quad \frac{A;\ e_1 \implies n_1 \quad A;\ e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{A;\ e_1+e_2 \implies n_3}$

<details>
  <summary>Solutions!</summary>

1.
    
![image](https://hackmd.io/_uploads/rkGQ1UEayx.png)

2.

![image](https://hackmd.io/_uploads/SJ3b18NTyx.png)

3.
    
![image](https://hackmd.io/_uploads/HJx-JLE61x.png)

4.
    
![image](https://hackmd.io/_uploads/BJYl1UVake.png)

</details>

## Additional Readings & Resources

- [Professor Mamat's Operational Semantics Slides](https://bakalian.cs.umd.edu/assets/slides/17-semantics.pdf)
- [Fall 2022 - Discussion 10 (Operational Semantics)](https://github.com/umd-cmsc330/fall2022/tree/main/discussions/discussion10#operational-semantics)
- [OpSem Problem Generator](https://bakalian.cs.umd.edu/330/practice/opsem)
