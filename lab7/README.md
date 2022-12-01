# COMP 311: SP 2022 - Lab 07

## Binary Pattern Generation

## Lab Objective

In this lab you will be implementing a MIPS program that utilizes recursion. Recursion is the process a procedure goes through when one of the steps of the procedure involves invoking the procedure itself. It is one of the most important and frequent methods used in Computer Science. Now that you have a taste of protocol calls in MIPS, we will test it further by asking you to write a recursive MIPS program that prints all binary patterns of length N.

## Coding Problem

In this assignment, you will write a MIPS program that read an integer range from 1 to 16, generate all binary patterns of length N, and output them line by line. In particular, the step-by-step procedure is:

1. Prompt the user to enter a number between 1 and 16 (inclusive), which will be the number of bits a single result string will have.
2. Write a recursive function to generate all strings that meet the condition.
3. Output all your strings. The smaller the number which the string represents in binary, the earlier it should be printed.
4. Terminate the program.
5. Since it is a fairly short lab (around 60 lines without blank lines and comments), the I/O is not given.

## Assignment Instructions

Please download the provided lab7.asm file from the github repo and complete the MIPS code in the two TODO sections:

- PART 1 in which you will complete the body of the main procedure.
- PART 2 in which you will complete the body of the recursive procedure.

## Example I/O

```
Enter the number of bits (N): 3 
000
001
010
011
100
101
110
111
```

## Program Specifications

- The name of your program file must be lab7.asm.
- Exception / Error handling is not required. That is, assume only valid values are entered by the user.
- The input and output must be the same as the examples provided above, in terms of: spelling, spacing, cases, etc.

## Assignment Submission and Grading Rubric

Assignment submissions will be made through [GradeScope](https://www.gradescope.com).

You should already be enrolled in the COMP 311 Spring 2022 course on GradeScope. If you are not, please self enroll with entry code **X3PR75**. If you're unable to self enroll, please contact your cohort leader and we'll manually add you.

To submit your assignment, please follow the basic steps provided below. If you're unable to perform any of the steps, please reach out to your **cohort** and **cohort leader** as soon as possible. That is, give yourself time to resolve any technical issues using Github, Github Desktop, and Gradescope well before the assignment due date.

1. Submit modifications using the **commit** Github Desktop instructions.
2. Update remote (origin) repository using the **push** Github Desktop instructions.
3. Go to the COMP 311 course in GradeScope and click on the assignment called **Lab 07**.
4. Click on the option to **Submit Assignment** and choose GitHub as the submission method. You may be prompted to sign in to your GitHub account to grant access to GradeScope. When this occurs, **make sure to grant access to the Comp311-SP22 organization**.
5. You should see a list of your public repositories. Select the one named **lab-07-yourname** and submit it.
6. Your assignment should be autograded within a few seconds and you will receive feedback.
7. If you receive all the points, then you have completed this lab assignment! Otherwise, you are free to keep pushing commits to your GitHub repository and submit for regrading up until the deadline of the lab.
