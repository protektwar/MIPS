.data
matrixA:          .space 144 # max as the matrix will be 6 x 6, and we have to multiply with 4 as each element will be stored on 4 bytes
matrixB:          .space 144 
matrixC:          .space 144
matrixSize:       .word 0

helloMsg:        .asciiz "Welcome to the Matrix Kultiplier NEO\n" # null terminated string
matrixSizeMsg:   .asciiz "Please enter the size of the Matrix 2-6: "
matrixElemMsg:   .asciiz "Enter the Matrix elements one after the other:\n"
printMatrixA:    .asciiz "Printing Matrix A:\n"
printMatrixB:    .asciiz "Printing Matrix B:\n"
printMatrixC:    .asciiz "Printing Matrix C: Results of A x B\n"
space:           .asciiz  " "
eol:             .asciiz  "\n"

.text

.globl main
main:

  la $a0, helloMsg
  jal welcomeMessage
  
  la $a0, matrixSizeMsg
  jal readMatrixSize
  
  sw $v0, matrixSize #storing the returned value from $v0 into matrixSize
  
  la $a0, matrixA
  lw $a1, matrixSize
  la $a2, matrixElemMsg
  jal readMatrix
  
  la $a0, matrixA
  lw $a1, matrixSize
  la $a2, printMatrixA
  jal printMatrix
  
  la $a0, matrixB
  lw $a1, matrixSize
  la $a2, matrixElemMsg  
  jal readMatrix

  la $a0, matrixB
  lw $a1, matrixSize
  la $a2, printMatrixB
  jal printMatrix
  
  la $a0, matrixA
  la $a1, matrixB
  la $a2, matrixC
  lw $a3, matrixSize
  jal kultiplierMatrix
  
  la $a0, matrixC
  lw $a1, matrixSize
  la $a2, printMatrixC
  jal printMatrix
  
  j exit

welcomeMessage:
  li $v0, 4    #print string   
  # $a0 already have the address of the string to be printed, as it was sent as parameter
  syscall 
  
  jr $ra

readMatrixSize:

  li $v0, 4
  # $a0 already have the address of the string to be printed, as it was sent as parameter
  syscall

    li $v0, 5    #read interger
  syscall
  # $v0 will have the value which will be futher returned 
  
  jr $ra
 
readMatrix:

  move $t0, $a0  # matrix address
  move $t1, $a1  # matrix size

  li   $v0,4 
  move $a0, $a2
  syscall
    
  li $t3, 0      #matrix row index
forRow:

  li $t2, 0      #matrix col index
forCol:

  # (x*Size + y)*4
  mul  $s0, $t3, $t1
  add  $s0, $s0, $t2
  mul  $s0, $s0, 4
  
  add  $s0, $s0, $t0

  li $v0, 5          #read integer
  syscall
  
  sw $v0, 0($s0)
  
  addi $t2, $t2, 1    #j++
  blt  $t2, $t1, forCol    #we keep going until the end of the loop
                        #    }

  addi $t3,$t3, 1       #i++
  blt  $t3, $t1, forRow  
                        #    }
  jr $ra

printMatrix:

  move $t0, $a0  # matrix address
  move $t1, $a1  # matrix size
  
  li $v0, 4
  move $a0, $a2
  syscall
  
  li $t3, 0      #matrix row index
forRowPrint:

  li $t2, 0      #matrix col index
forColPrint:

  # (x*Size + y)*4
  mul  $s0, $t3, $t1
  add  $s0, $s0, $t2
  mul  $s0, $s0, 4
  
  add  $s0, $s0, $t0

  lw $a0, 0($s0)
  
  li $v0, 1          #print integer
  syscall

  li $v0, 4        
  la $a0, space
  syscall
  
  addi $t2, $t2, 1    #j++
  blt  $t2, $t1, forColPrint    #we keep going until the end of the loop
                        #    }

  li $v0, 4         #print character
  la $a0, eol
  syscall
  
  addi $t3,$t3, 1       #i++
  blt  $t3, $t1, forRowPrint  
                        #    }
  jr $ra

kultiplierMatrix:

  move $t0, $a0  # matrix address A 
  move $t5, $a1  # matrix address B
  move $t6, $a2  # matrix address C
  move $t1, $a3  # matrix size

  li   $v0,4 
  move $a0, $a2
  syscall
    
  li $t3, 0      #matrix row index
for1Kul:

  li $t2, 0      #matrix col index
for2Kul:

  li $t4, 0      #matrix col index
  li $s5, 0      
  mul  $s0, $t3, $t1  # C[i,j] 
  add  $s0, $s0, $t2
  mul  $s0, $s0, 4
  add  $s0, $s0, $t6

for3Kul:
  
  mul  $s1, $t3, $t1  # A[i,k]
  add  $s1, $s1, $t4
  mul  $s1, $s1, 4
  add  $s1, $s1, $t0
  
  lw $s3, 0($s1)
  
  mul  $s2, $t4, $t1  # A[k,j]
  add  $s2, $s2, $t2
  mul  $s2, $s2, 4
  add  $s2, $s2, $t0
  
  lw $s4, 0($s2)
  
  mul $s3, $s3, $s4
   
  add $s5, $s5, $s3 
  
  addi $t4, $t4, 1    #k++
  blt  $t4, $t1, for3Kul    #we keep going until the end of the loop
  
  sw $s5, 0($s0)   # store at C[i,j]  
  
  addi $t2, $t2, 1    #j++
  blt  $t2, $t1, for2Kul    #we keep going until the end of the loop
                        #    }

  addi $t3,$t3, 1       #i++
  blt  $t3, $t1, for1Kul  
                        #    }

  jr $ra   
                  
exit: 
  li $v0, 10
  syscall 
  
  
  
