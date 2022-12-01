.data
randomizer: .word 0x995

.text

main:
	
	li $a0, 10 # X
	li $a1, 4  # Y
	jal generate_random
	move $a0, $v1
	li $v0, 1
	syscall
	
	li $a0, 10 # X
	li $a1, 4  # Y
	jal generate_random
	move $a0, $v1
	li $v0, 1
	syscall

	li $a0, 10 # X
	li $a1, 4  # Y
	jal generate_random
	move $a0, $v1
	li $v0, 1
	syscall
	
	li $a0, 10 # X
	li $a1, 4  # Y
	jal generate_random
	move $a0, $v1
	li $v0, 1
	syscall

	j end_Program
	
generate_random: 
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	jal multiply  #mul X*Y
	li $a0, 0xe9a5
	lw $t0, randomizer
	add $a0, $a0, $t0
	move $a1, $v0
	jal multiply
	move $a0, $v0
	sw $v0, randomizer
	li $a1, 4
	jal divide # $v0 will have the return value from generate_random

generate_random_exit:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

multiply: 
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	move $t2, $a0
	move $t3, $a1
	li   $t4, 0   # multipler index
	
multiply_loop:
	bge $t4, $t3, multiply_loop_end
	
	addu $t2, $t2, $t3
	addi $t4, $t4, 1
	
	j multiply_loop

multiply_loop_end:
	move $v0, $t2

multiply_exit:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
		
divide:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	move $t2, $a0
	move $t3, $a1
	li   $t4, 0   # quotient
	
divide_loop:
	blt $t2, $t3, divide_loop_end
	
#	move $a0, $t2
#	move $a1, $t3
#	jal subtract
	sub $t2, $t2, $t3
	addi $t4, $t4, 1
	
	j divide_loop

divide_loop_end:
	move $v0, $t4
	move $v1, $t2
divide_exit:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
subtract:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	move $t0, $a0
	move $t1, $a1
	
subtract_loop:
	beq $t1, $zero, subtract_loop_end
	
	addi $t0, $t0, -1
	addi $t1, $t1, -1
	
	j subtract_loop
	
subtract_loop_end:
	move $v0, $t0

subtract_exit:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
			
end_Program:

	li $v0, 10
	syscall
