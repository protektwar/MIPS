.data
array: .word 13, 6, 8, 1, -7, 19, 25, 101, 52, -18
even_prompt: .asciiz "Even number count: "
odd_prompt: .asciiz "\nOdd number count: "


.text
main:
  li $t0, 0
  la $t2, array
  li $t7, 0
  li $t8, 0

loop:
  bge $t0, 10, print
  mul $t1, $t0, 4
  add $t1, $t1, $t2    
  
  lw $a0, 0($t1)                # param for is_even
  jal is_even
  beq $v0, 1, count_even        # check returned value is 1 then even else odd
  
count_odd:
  addi $t7, $t7, 1
  j next
  
count_even:
  addi $t8, $t8, 1
  
next:
  addi $t0,$t0,1
  b loop

is_even:                   #is_even? return 1 if yes 0 if not
  div $t5, $a0, 2
  mfhi $t5
  beq $t5, 0, even
odd: 
  addi $v0, $0, 0
  j exit_is_even
even: 
  addi $v0, $0, 1
  
exit_is_even:
  jr $ra

print:
  li $v0,4
  la $a0, even_prompt
  syscall

  li $v0,1
  move $a0,$t8
  syscall
  
  li $v0,4
  la $a0, odd_prompt
  syscall

  li $v0,1
  move $a0,$t7
  syscall

exit:
  li $v0, 10
  syscall
