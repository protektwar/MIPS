.data

.text

main:

#"Enter num: "
# 0x65746e45  
# 0x756e2072
# 0x00203a6d

#"Array length: "
# 0x61727241
# 0x656c2079
# 0x6874676e
# 0x0000203a

   li $a0, 4
   li $v0, 9
   syscall
   
   move $s5, $v0
   li $t0, 0x00000020
   sw $t0, 0($s5)

   li $a0, 12
   li $v0, 9
   syscall
   
   move $s6, $v0             # address of message "Enter num: "
   li $t0, 0x65746e45
   sw $t0, 0($s6)
   li $t0, 0x756e2072
   sw $t0, 4($s6)
   li $t0, 0x00203a6d
   sw $t0, 8($s6)
         
   li $a0, 16 
   li $v0, 9
   syscall

   move $s7, $v0             # address of message "Array length: "
   li $t0, 0x61727241
   sw $t0, 0($s7)
   li $t0, 0x656c2079
   sw $t0, 4($s7)
   li $t0, 0x6874676e
   sw $t0, 8($s7)
   li $t0, 0x0000203a
   sw $t0, 12($s7)

#read array Lenght  
   li $a0, 4
   li $v0, 9
   syscall
   
   move $s1, $v0             #array length address
   
   move $a0, $s7             #print "Array length: "
   li $v0, 4
   syscall
   
   li $v0, 5                 #read integer
   syscall
    
   sw $v0, 0($s1)            #store at $s1 address the length of array
   
   mul $t1, $v0, 4
   move $a0, $t1               #alocate memory for length of array * 4
   li $v0, 9
   syscall
   
   move $s2, $v0             # array elemetns address
        
   
#read array Elements
   li $t0, 0                 #init for loop index
   lw $t1, 0($s1)
forLoopElements:
   sll $s3, $t0, 2           # calculate address of array element
   add $s3, $s3, $s2         # add to array address

   move $a0, $s6             # print string "Enter num: " 
   li $v0, 4
   syscall
  
   li $v0, 5
   syscall
   
   sw $v0, 0($s3)             #store element at calculated address 
   
   addi $t0, $t0, 1
   blt $t0, $t1, forLoopElements 

#call insertion_sort
   move $a0, $s2                # param 1 array address
   lw $a1, 0($s1)                # param 2 array length
   jal insertion_sort

   lw $t1, 0($s1)             #array length
#print the sorted array
   li $t0,0                   # init for loop index
forLoop:
   sll $s0, $t0, 2
   add $s0, $s0, $s2
   
   lw $a0, 0($s0)             # load int from array to be printed
   li $v0, 1
   syscall
   
   move $a0, $s5  # address of string to print " "
   li $v0, 4
   syscall
   
   addi $t0, $t0, 1
   blt $t0, $t1, forLoop   

exit:
  li $v0, 10
  syscall

insertion_sort:
  
  move $t5, $a0                # array address
  move $t6, $a1                # array length
  li $t0, 1                    # index for forInRange  

forInRange:                    # for i in range(1, length):
  sll $s0, $t0, 2
  add $s0, $s0, $t5
  
  lw $t2, 0($s0)               # key = the_list[i]  
  
  addi $t1, $t0, -1            # j = i-1
    
while:                         # while j >= 0 and key < the_list[j]:
  sll $s0, $t1, 2
  add $s0, $s0, $t5
  lw $t3, 0($s0)               # the_list[j]
  blt $t1, 0, exitWhile        # j >= 0
  bge $t2, $t3, exitWhile      # key < the_list[j]
   
  add $s0, $s0, 4
  sw $t3, 0($s0) 

  add $t1, $t1, -1             #j -= 1
  
  add $t1, $t1, 1              # j + 1
  
  sll $s0, $t1, 2
  add $s0, $s0, $t5            # calculate address of the_list[j + 1]
  
  sw $t2, 0($s0)               # the_list[j + 1] = key
  add $t1, $t1, -1              # j + 1
  
  j while
# end while
exitWhile:

  add $t0, $t0, 1
  blt $t0, $t6, forInRange

#end forInRange

  jr $ra                       # return from function
  
