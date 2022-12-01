.data
matrixA:          .space 324 
matrixB:          .space 324 
matrixC:          .space 324
matrixRow:        .word 0
matrixColumn:     .word 0

matrixRowSizeMsg:   .asciiz "how many rows in your matrices (max 9)? "
matrixColumnSizeMsg:.asciiz "how many columns in your matrices (max 9)? "
matrixAskMsg:    .asciiz "for matrix number "
matrixRowMsg:  .asciiz "enter row "
matrixColumnMsg:  .asciiz " column "
columnSpaceMsg:  .asciiz ": "
resultMsg:       .asciiz "RESULTS\n"
plusMsg:         .asciiz "plus\n"
equalMsg:        .asciiz "EQUALS\n"
space:           .asciiz  " "
eol:             .asciiz  "\n"

.text

.globl main
main:

  li $v0, 4                 # print string syscall 4
  la $a0, matrixRowSizeMsg  # load message address to $a0
  syscall                   
  
  li $v0, 5
  syscall
  sw $v0, matrixRow         #store row value in matrixRow
  
  li $v0, 4
  la $a0, matrixColumnSizeMsg # load message address to $a0
  syscall

  li $v0, 5
  syscall
  sw $v0, matrixColumn     #store column value in matrixColumn
        
  la $a0, matrixA          #load address of matrixA in $a0
  lw $a1, matrixRow        #load row value in $a1
  lw $a2, matrixColumn     #load column value in $a2
  li $a3, 1                #load matrix number in $a3
  jal readMatrix
   
  la $a0, matrixB          #load address of matrixB in $a0
  lw $a1, matrixRow        #load row value in $a1
  lw $a2, matrixColumn     #load column value in $a2
  li $a3, 2                #load matrix number in $a3
  jal readMatrix
  
  la $a0, matrixA          #load address of matrixA in $a0
  la $a1, matrixB          #load address of matrixB in $a1
  la $a2, matrixC          #load address of matrixC in $a2 <- result will be stored
  jal addMatrix            #call addMatrix
  
  li $v0, 4                # print string
  la $a0, resultMsg        # load message address to $a0
  syscall 
  
  la $a0, matrixA          #load address of matrixA in $a0
  lw $a1, matrixRow        #load row value in $a1
  lw $a2, matrixColumn     #load column value in $a2
  jal printMatrix          #call printMatrix

  li $v0, 4         #print string
  la $a0, plusMsg   # load message address to $a0
  syscall 

  la $a0, matrixB          #load address of matrixB in $a0
  lw $a1, matrixRow        #load row value in $a1
  lw $a2, matrixColumn     #load colulmn value in $a2
  jal printMatrix          #call printMatrix

  li $v0, 4         #print string
  la $a0, equalMsg  # load address to $a0  
  syscall 

  la $a0, matrixC         #load address of matrixC in $a0
  lw $a1, matrixRow       #load row value in $a1
  lw $a2, matrixColumn    #load column value in $a2
  jal printMatrix         #call printMatrix
  
  j exit

readMatrix:

  move $t0, $a0  # matrix address
  move $t1, $a1  # matrix row
  move $t2, $a2  # matrix column
  move $t3, $a3  # matrix number

  li   $v0,4           #print string 
  la $a0, matrixAskMsg # load message addres in $a0
  syscall
  
  li $v0, 1            #print matrix number
  move $a0, $t3 
  syscall
  
  li $v0, 4            #print string "\n"
  la $a0, eol
  syscall
    
  li $t5, 0      #matrix row index
forRow:

  li $t4, 0      #matrix col index
forCol:

  mul  $s0, $t5, $t2 # $s0 = x*Size
  add  $s0, $s0, $t4 # $s0 = (x*Size + y)
  mul  $s0, $s0, 4   # $s0 = (x*Size + y)*4 
  
  add  $s0, $s0, $t0 # $s0 = $s0 + matrix address

  li   $v0,4             #print message
  la $a0, matrixRowMsg
  syscall
  
  li $v0, 1              #print current row number
  move $a0, $t5
  addi $a0, $a0, 1
  syscall


  li $v0,4               #print message
  la $a0, matrixColumnMsg
  syscall
  
  li $v0, 1              #print current column number
  move $a0, $t4 
  addi $a0, $a0, 1
  syscall

  li $v0,4               #print message
  la $a0, columnSpaceMsg 
  syscall

  li $v0, 5             #read value for matrix[i][j]
  syscall       
  
  sw $v0, 0($s0)        #store read value at address of matrix[i][j]
  
  addi $t4, $t4, 1    #j++
  blt  $t4, $t2, forCol    #we keep going until the end of the loop
                        #    }

  addi $t5,$t5, 1       #i++
  blt  $t5, $t1, forRow  

readMatrix_exit:        # exit function
  jr $ra

printMatrix:

  move $t0, $a0  # matrix address
  move $t1, $a1  # matrix size
  
  
  li $t3, 0      #matrix row index
forRowPrint:

  li $t2, 0      #matrix col index
forColPrint:

  # (x*Size + y)*4
  mul  $s0, $t3, $t1
  add  $s0, $s0, $t2
  mul  $s0, $s0, 4
  
  add  $s0, $s0, $t0

  lw $a0, 0($s0)     #load to $a0 value from matrix[i][j]
  
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

addMatrix:

  move $t0, $a0  # matrix address A 
  move $t1, $a1  # matrix address B
  move $t2, $a2  # matrix address C
  
  lw $t6, matrixRow # load row value 
  lw $t7, matrixColumn #load column value 

  li $t5, 0      #matrix row index
forRow1:

  li $t4, 0      #matrix col index
forCol1:

  # (x*Size + y)*4
  mul  $s0, $t5, $t7
  add  $s0, $s0, $t4
  mul  $s0, $s0, 4
  
  add  $s1, $s0, $t0  # $s1 = $s0 + address of matrixA
  add  $s2, $s0, $t1  # $s2 = $s0 + address of matrixB
  add  $s3, $s0, $t2  # $s3 = $s0 + address of matrixC
  
  lw $s4, 0($s1)      #load value at matrixA[i][j]
  lw $s5, 0($s2)      #load value at matrixB[i][j]
  add $s6, $s4, $s5   #sum up above values
  sw $s6, 0($s3)      #store value at matrixC[i][j]
    
  addi $t4, $t4, 1    #j++
  blt  $t4, $t7, forCol1    #we keep going until the end of the loop
                        #    }

  addi $t5,$t5, 1       #i++
  blt  $t5, $t6, forRow1 
  
addMatrix_exit:    #exit function

  jr $ra   
                  
exit:              #end of program
  li $v0, 10
  syscall 
  
  
  
