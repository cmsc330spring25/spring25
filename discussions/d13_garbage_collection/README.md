# Discussion 13 - Friday, May 2nd

## Reminders

- Quiz 4 today! There are 25 minutes to complete the quiz.
- Project 7 is out! Due **Tuesday, May 13th, at 11:59 PM**.

## Garbage Collection

In lecture, we learned about three main ways to do garbage collection:

* **Reference Counting** - Keep track of how many references point to a piece of memory, and free that memory once the counter reaches 0.
* **Mark & Sweep** - Has two phases, mark and sweep. In the mark phase, we mark all chunks of memory reachable via the stack. In the sweep phase, we go through the heap and deallocate all non-marked (non-reachable) chunks of memory. 
* **Stop & Copy** - Similar to Mark & Sweep, but instead of freeing unreachable heap memory segments, we copy reachable segments to an alternate partition. Once a partition is completely freed from stack references, we swap to using that partition.

## Exercises

### Reference Counting

Consider the following stack + heap layouts. For each, answer the following:
1. What would a reference counter diagram look like at time of first diagram?
2. What would it look like after each variable is popped off the stack?

![image](https://hackmd.io/_uploads/SkngkF6yxg.png)


![image](https://hackmd.io/_uploads/H1sioYpkgg.png)


<details>
  <summary>Solution!</summary>

![image](https://hackmd.io/_uploads/BJeVktpyxe.png)
    
For the following assume `d`s are arbitrary data on the heap.
    
![image](https://hackmd.io/_uploads/HJD-2tpyeg.png)

</details>

### Mark & Sweep

Consider the following stack + heap layouts. For each, answer the following:
1. What would a mark and sweep diagram look like if called at time of first diagram?
2. What would it look like after each variable is popped off the stack?

![image](https://hackmd.io/_uploads/HJvZkFa1le.png)

For the following assume `d`s are arbitrary data on the heap.

![image](https://hackmd.io/_uploads/H1WLnFaJxx.png)


<details>
  <summary>Solution!</summary>

![image](https://hackmd.io/_uploads/SkeUyt61gl.png)
    
![image](https://hackmd.io/_uploads/r1PwntpJxl.png)

</details>

### Stop and Copy

Consider the following stack + heap layout. For each, answer the following:
1. What would a stop and copy diagram look like if called at time of first diagram?
2. What would it look like after each variable is popped off the stack?
3. \+ how are these different than mark and sweep?

![image](https://hackmd.io/_uploads/H1chEc6Jll.png)


\* **NOTE for solutions**: For the first solution (to Q1 above), there is only one solution. For the rest, there is a simplified and  a detailed version. The detailed version is most accurate, the simplified version hides some inaccessible data from previous passes to help focus on what has just happened in that pass. Simplified version is more similar to project 7.
    
In the detailed versions, the blue data is overwriting what was in that spot before. Recall that in stop and copy nothing is ever freed, just overwritten!

<details>
  <summary>Solution!</summary>
    
![image](https://hackmd.io/_uploads/ryo7IqTJxg.png)

![image](https://hackmd.io/_uploads/rkxVLc6kex.png)
    

</details>

### Additional Resources
- [Cliff's Garbage Collection Notes](https://bakalian.cs.umd.edu/assets/notes/gc.pdf)
- [Anwar's Garbage Collection Slides](https://bakalian.cs.umd.edu/assets/slides/23-memory-management.pdf)
