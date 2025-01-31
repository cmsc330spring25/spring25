# Discussion 1 - Friday, January 31

## Reminders
- Discussion participation can grant you up to 1% extra credit. We will start counting participation after add/drop is over (February 14th).
  - You will need to stay after the quiz is done on quiz days in order to earn participation credit. (Quizzes occur in the first 25 minutes of discussion)
- Project 0 released, due **Monday, February 3rd @ 11:59 PM**
- Project 1 released, due **Monday, Febuary 10th @ 11:59PM**
- We are using [Quuly](https://officehours.cs.umd.edu) for office hours queue. The code to join is **d97a2**
  - If you do not join the queue on Quuly, you **cannot** expect a TA to know you need help.
- [Late token policy]([#4-late-tokens](https://github.com/cmsc330spring25/spring25/blob/main/projects/project0/project0.md#windows)) 
- The [Makeup Policy](https://piazza.com/class/m6687mvdhig1iw/post/8) can be found on the syllabus and on Piazza. 

## Course Setup

### What is Git?

1. Git is an open-source version control system
2. Make sure to [set up an SSH key](https://github.com/cmsc330spring25/spring25/blob/main/projects/project0/project0.md#set-up-ssh-authentication) to securely authenticate yourself (refer to Project 0 for detailed instructions on how to do this).
   - If you are on windows, you will need to install WSL before making the SSH key, you can also find instructions for this in [project 0](https://github.com/cmsc330spring25/spring25/blob/main/projects/project0/project0.md#windows)

### Cloning Project Repositories

1. Navigate to Class GitHub (located on the top right of the [class page](https://bakalian.cs.umd.edu/330))
2. Under **Project Links**, click on the project you want to initialize (i.e. **Project 0**)
3. Accept the project
4. Once you accept the project, open the link
5. You will now see your project repository, click on the green `<> Code` button on the top right of your screen.
6. Once clicked on `<> Code`, click on the SSH tab under Clone options and copy the **SSH** link to your repository
7. Once you have the link, make a directory to hold all your projects with `mkdir <project-folder-name>` and then move into the directory with `cd <project-folder-name>`
8. Clone your repository by running `git clone <paste link to your repo here>`
9. Go into your new repository: `cd <repo name>`

### Staging, Committing, and Pushing Changes

1. Make text file in the repository directory on your machine: `touch hello.txt`
2. Add: `git add .` (the `.` after `git add` refers to the entire current directory, you can also add specific files/directories like so: `git add <file.txt>`)
3. Commit: `git commit -m “some useful message here”`
4. Push: `git push`


### Pulling Changes

1. Edit text file on GitHub website (in your browser)
2. Pull: `git pull`


### Late Tokens
>[!IMPORTANT]
> In projects, you have 3 24-hour extension tokens to use. You can only use one per project. This is done by modifying the contents of the LATE_TOKEN file from `false` to `true` and submitting after the deadline has passed.
> 
> Once you use a token (submit with the LATE_TOKEN contents = true), you **will not be able to change it even if you submit with contents = false later**. Once it is used, it is locked in!



Please refer to the course syllabus on any other late token policies.

Feel free to accept and submit this sample assignment to try out using late tokens (it will not use up any of your real tokens): https://classroom.github.com/a/De85vror

### Confirming your Submission

After submitting, please make sure to *always* check Gradescope to confirm that everything has been submitted as expected with no errors either on the side of the autograder or on the side of the submission.

Here is what your Gradescope will look like when...

1. Submitting on time (late tokens have no effect): ![sontime](https://hackmd.io/_uploads/HkDoQ5KOJe.png) 
Your score will be whatever you earned based on the tests, and you will be able to see which tests you pass and fail. You can tap the "Code" button on the top right to see what code was submitted.

2. Submitting within the 1 day late deadline (no late token used): ![skinda](https://hackmd.io/_uploads/HkprUcK_1e.png)
Your score will be whatever you earned based on the tests *minus 10%* for the late penalty. The autograder tells you that the late penalty has been applied and no token was used.

3. Submitting within the 1 day late deadline (late token used): ![sfair](https://hackmd.io/_uploads/BJLtB5Ydkx.png)
Your score will be whatever you earned based on the tests with no penalty applied. The autograder tels you that the late penalty was waived because a token was used, and you will have one less token from now on (even if you remove the token and resubmit).

4. Submitting more than 1 day late (late tokens no longer apply): ![slate](https://hackmd.io/_uploads/ryzKV9FOyl.png)
Your score will be 0/100.0 since you submitted past the late deadline *even though the tests are still passing*. The autograder will let you know if enough tests are passing for you to achieve the GFA requirement. 








