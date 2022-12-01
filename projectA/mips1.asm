
.data
CharStr: .asciiz "AEZKLBXWZXYALKFKWZRYLAKWLQLEK"
ResultArray: .space 26
ReturnMsg1: .asciiz "The most freq char: "
ReturnMsg2: .asciiz " ,Occurence count: "
.text
.globl main
main: 
	la $a0 , CharStr 
	la $a1 , ResultArray
	
	jal char_occurrences
	
	
	move $t0, $v0
	move $t1, $v1
	
	li $v0,4
	la $a0,ReturnMsg1
	syscall 
	
	li $v0, 11
	move $a0,$t0 
	syscall 
	
	li $v0,4
	la $a0,ReturnMsg2 
	syscall
	
	li $v0, 1
	move $a0,$t0 
	syscall
	
	li $v0,10
	syscall 	
	
char_occurrences:

	move $t2 , $a0
	move $t4 , $a1
	
	li $t0,'A' 		# reset the t0 to A char  
	move $t1, $zero		# reset the index to zero
	
	move $t6 , $zero 	
	move $t7 , $t0
	
for_loop: 			# Start of the for loop (iterates over the chars A-Z)  
	move $t5, $zero		# reset the char ocuurance count.
	move $s0, $t2
	
	
while_loop: 			# Start the while loop (iterates over the CharStr chars)
	
	lb $t3 , ($s0) 		# save to $t3 the value of the address saved in $t2 (the cuurent charStr)
	beq $t3, '\0', end_while_loop # if ($t3==null) break . (end of the string) 
	
		
	addi $s0, $s0,1		# increment the cuurent char address in order reading the next char . 
	bne $t3 , $t0 , while_loop # if the cuurent char in CharStr is not the char saved in $t0 , break; 
	
	
	addi $t5,$t5,1		# else - increment the char occurrence count by 1 
	
	j while_loop		# jump to the start of the while loop ( to iterate over the next char in CharStr. 
	
end_while_loop:

	sb $t5,($t4)		# store the char occurrence count to $t5 (the place of the char count in ResultArray)  
	
	move $a0, $t5
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	blt $t5, $t6, continue_for_loop 
	
	move $t6 , $t5 
	move $t7 , $t0 
	 
continue_for_loop: 	
	addi $t4,$t4, 1		# move to the next element in the ResultArray
 	addi $t1,$t1, 1		# increment the for loop index by 1
 	addi $t0,$t0, 1 	# move to the next char (A-Z)
 	blt $t1,26, for_loop  	# if index >= 26 then break;
	
	move $v1, $t6
	move $v0, $t7
	
	jr $ra
