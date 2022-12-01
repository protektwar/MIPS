.data 

result: .space 4
num1: .word -8,num3
num2: .word 1988,0 
num3: .word -9034,num5 
num4: .word -100, num2
num5: .word 1972, num4 

.text

main:

	li   $a0, 128  #numbers of bytes to allocated
	li   $v0, 9    #sys function allocate heap memory
	syscall
	
	la $t1, result
	sw $v0, ($t1)  #store the address of the allocated heap memory in result

	la $t0, num1

while:
	lw $a0, ($t0)

print_value:
  
        lw $a0, ($t0)
	li $v0, 1
	syscall
	
	lw $a0, ($t0)
	jal base10to4
	
	li $a0, '\n'
	li $v0, 11
	syscall


	addi $t0, $t0, 4
	
	lw $t0, ($t0)
		
	beq $t0, 0, end_while 
	
	j while
	
end_while:

end_program:
	li $v0, 10
	syscall

base10to4:


	move $s0,$a0
	la   $s7,result	


	li $a0, '|'
	li $v0, 11
	syscall

	li   $s1, 4
	li   $s2, 0 #index for the result array
	li   $s6, 0 #will keep track if number is negative of positive 
	
divide_loop:
	
	beq  $s0, $zero, end_loop
	
	div  $s0, $s0, $s1
	mfhi $s5
	
	
	move $s3, $s2 
	mul  $s3, $s3, $s1
	lw   $s4, ($s7)
	add  $s3, $s3, $s4
	blt  $s5, $zero, negative
	j    next

negative:
	li   $s6, 1	
	mul  $s5, $s5, -1 # if negative then make positive

next:
	sw   $s5, ($s3)

	addi $s2, $s2, 1 #increment index with 1
	j divide_loop
	
end_loop:	

print_result:
        # $s2 will contain the range of result array
	addi $s2, $s2, -1
	beq $s6, 1, print_minus
        j print_loop
        
print_minus:

	li   $a0, '-'
	li   $v0, 11
	syscall

	          	          
print_loop: 
	blt $s2, $zero end_print_loop
	
	move $s3, $s2 
	mul  $s3, $s3, 4
	lw   $s4, ($s7)
	add $s3, $s3, $s4
	lw   $s5, ($s3)

	addi $s2, $s2, -1 #increment with 4 for the next address memory location
	
	move $a0, $s5
	li   $v0, 1
	syscall
	
	
	j print_loop
	
end_print_loop:

return_base10to4:

	jr $ra