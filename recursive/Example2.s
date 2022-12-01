.data 
  test:      .word 4

.text

.globl main

main:

   lw $a0, test
   jal printFun
   
   j exit  
  
exit:
   li $v0, 4
   syscall
  
printFun:                  #void printFun(int test)
#{
   addi $sp, $sp, 4      # change stack pointer accordingly
   sw   $ra, 0($sp)      # save returning address $ra
   
   move $t0, $a0
   li   $t1, 1
   
   blt $t0, $t1, exit_printFun   # if (test < 1) return;
# else {
   
# cout << test << " ";
   li $v0, 1
   syscall
   
   addi $sp, $sp, 8      # change stack pointer accordingly
   sw   $t0, 4($sp)      # save returning address $ra
   sw   $a0, 0($sp)      # save returning address $ra
   
# printFun(test - 1);
   addi $t0, $t0, -1
   move $a0, $t0
   jal printFun

   lw   $a0, 0($sp)      # save returning address $ra
   lw   $t0, 4($sp)      # save returning address $ra
   addi $sp, $sp, -8      # change stack pointer accordingly
      
   li $v0, 1
   syscall
# cout << test << " ";
#}
exit_printFun:
# return;
   lw   $ra, 0($sp)      # load returning address in $ra from stack
   addi $sp, $sp, -4     # change stack pointer accordingly

   jr $ra