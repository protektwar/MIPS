.data

arrayLengthMsg: .asciiz "Array Lenght: "
enterNumMsg:    .asciiz "Enter num: "
enterTargetMsg:  .asciiz "Enter target: "

.text
main:
   jal readArrayLength
   add $s0, $0, $v0       #store in $s0 array length
   
   add $a0, $0, $s0       #send array length as param
   jal allocMemArray
   add $s1, $0, $v0
   
   add $a0, $0, $s0       #send array length as param
   add $a1, $0 $s1       #send array address as param
   jal readArrayNums

   jal readTarget
   add $s2, $0, $v0
   
   add  $a0, $0, $s1     # array address
   add  $a1, $0, $s2     # target
   addi $a2, $0, 0       # 0
   add  $a3, $0, $s0     # array length
   jal bi_search 
   add $s3, $0, $v0       #result in index
   
   add $a0, $0, $s3       # send index as param
   jal printResult
   
   j exit
   
readArrayLength:
    
   addi $v0, $0, 4
   la $a0, arrayLengthMsg
   syscall 
   
   addi $v0, $0, 5
   syscall
   
   jr $ra

allocMemArray:

   sll $a0, $a0, 2    # param will be multiplied with 4, by shifting to the left 2 times and it will send further
   addi $v0, $0, 9
   syscall

   jr $ra

readArrayNums:

   add $t1,$0, $a0
   add $t2,$0, $a1
   add $t0, $0, $0     # init for index with 0
   
forLoop:
   sll $s3, $t0, 2           # calculate address of array element
   add $s3, $s3, $t2         # add to array address

   la $a0, enterNumMsg             # print string "Enter num: " 
   addi $v0, $0, 4
   syscall
  
   addi $v0, $0, 5                 # read int
   syscall
   
   sw $v0, 0($s3)             #store element at calculated address 

   addi $t0, $t0, 1
   slt $t7, $t0, $t1
   beq $t7, 1, forLoop

   jr $ra

readTarget:
   addi $v0, $0, 4
   la $a0, enterTargetMsg
   syscall 
   
   addi $v0, $0, 5
   syscall

   jr $ra

printResult:
                              #int to be printed will come as param
   addi $v0, $0, 1
   syscall   
   jr $ra
   
bi_search:
   addi $sp, $sp, 20      # change stack point accordingly
   sw   $ra, 16($sp)      # save returning address $ra
   sw   $t0, 12($sp)      # save $tx states before entering function
   sw   $t1, 8($sp)
   sw   $t2, 4($sp)
   sw   $t3, 0($sp)
   
   add $t0, $0, $a0       # array address
   add $t1, $0, $a1       # target
   add $t2, $0, $a2       # bottom
   add $t3, $0, $a3       # up
   
   slt $t7, $t3, $t2
   beq $t7, 1,  return_minus_1                    #bottom > up return -1   
   
   add $t4, $t2, $t3      # middle = up + bottom
   div $t4, $t4, 2        # middle /= 2
   
   add $t5, $0, $t4       #move array index to $t5
   sll $t5, $t5, 2        #mul index with 4, by shifting to the left 2 times
   add $t5, $t5, $t0      #add array address to index value
   
   lw $t6, 0($t5)         #load value at address location in $t5
   
   sub $t7, $t6, $t1
   beq $t7, 0, return_middle  # return middle
   
   slt $t7, $t1, $t6
   beq $t7, 1, return_middle_minus_1_bi_search # bi_search(a_list, aim, bottom, middle-1)
   
return_middle_plus_1_bi_search:                  # bi_search(a_list, aim, middle+1, up)
   add $a0, $0, $t0      # array address  
   add $a1, $0, $t1      # target 
   addi $t4, $t4, 1      # middle + 1
   add $a2, $0, $t4
   add $a3, $0, $a3      # up

   jal bi_search         # call recursivelly bi_search with jump and link

   j exit_bi_search      # exit function bi_search
   # call recursivelly bi_search with jump and link

return_middle_minus_1_bi_search:                # bi_search(a_list, aim, bottom, middle-1)
   add $a0, $0, $t0     # array address
   add $a1, $0, $t1     # target
   add $a2, $0, $t2     # bottom
   addi $t4, $t4, -1   
   add $a3, $0, $t4     # middle - 1
   
   jal bi_search        # call recursivelly bi_search with jump and link

   j exit_bi_search     # exit function bi_search
   
return_middle:
   add $v0, $0, $t4      #return middle
   j exit_bi_search      # exit function bi_search

return_minus_1:
   addi $v0, $0, -1       #return -1 
   j exit_bi_search       # exit function bi_search
   
exit_bi_search:   
   lw $t3, 0($sp)         # restore $tx reg before returning 
   lw $t2, 4($sp)
   lw $t1, 8($sp)
   lw $t0, 12($sp)
   lw $ra, 16($sp)        # restore returning address $ra
   addi $sp, $sp, -20     # change stack point accordingly

   jr $ra

exit:
   addi $v0, $0, 10
   syscall
