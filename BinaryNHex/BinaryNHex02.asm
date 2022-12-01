.data
	writeChar: .space 8
	first: .asciiz "Enter the first number: "
	second: .asciiz "Enter the second number: "
	dashLine: .asciiz "-------------------------------------------"
	addition: .asciiz "+"
	space: .asciiz " "
	hexMsg: .asciiz "in Hex"
	newLine: .asciiz "\n"
	exitMsg: .asciiz "program complete"
.text

	la $a0, first				# Print the first number statement
	jal firstInput				# Get the user's input
	move $s0, $v0				# Retrieve the user's input in $s0
	la $a0, second				# Print the second number statement		
	jal secondInput				# Get the user's input
	move $s1, $v0				# Retrieve the user's input in $s1
	li $v0, 4
	la $a0, newLine				# Print a new line
	syscall
	li $v0, 4	
	la $a0, space				# Print space
	syscall
	li $v0, 4
	la $a0, space				# Print space(again)
	syscall
	jal firstBinary				# Retrieve the first number in terms of binary
	li $v0, 4
	la $a0, addition			# Print the addition operator
	syscall
	li $v0, 4
	la $a0, space				# Print space
	syscall
	jal secondBinary			# Retrieve the second number in terms of binary
	li $v0, 4
	la $a0, dashLine			# Print dash line
	syscall
	li $v0, 4
	la $a0, newLine				# Print new line
	syscall
	jal adding
	li $v0, 4
	la $a0, space				# Print space
	syscall
	li $v0, 4
	la $a0, space				# Print space(again)
	syscall
	#jal sumBinary				# Retrieve the sum of two numbers in terms of binary
	
	jal sumNumbers
	move $s2, $v0
	li $v0, 4
	la $a0, newLine				# Print a new line
	syscall
	li $v0, 4
	la $a0, hexMsg				# Print hex message
	syscall
	li $v0, 4
	la $a0, newLine				# Print a new line
	syscall
	li $v0, 4
	la $a0, space				# Print space
	syscall 
	li $v0, 4
	la $a0, space				# Print space
	syscall
	jal firstHex				# Retrieve the first number in terms of hex
	li $v0, 4
	la $a0, addition			# Print the addition operator
	syscall
	li $v0, 4
	la $a0, space				# Print space
	syscall
	jal secondHex				# Retrieve the second number in terms of hex
	li $v0, 4
	la $a0, dashLine			# Print a dash line
	syscall
	li $v0, 4
	la $a0, newLine				# Print a new line
	syscall
	li $v0, 4
	la $a0, space				# Print a space
	syscall 
	li $v0, 4
	la $a0, space				# Print a space
	syscall
	jal sumHex				# Retrieve the sum of two numbers in terms of hex
	li $v0, 4
	la $a0, newLine				# Print a new line 
	syscall
	li $v0, 4
	la $a0, exitMsg				# Exit message
	syscall
	li $v0, 10				# Exit the program
	syscall
firstBinary:
	li $t0, 0x80000000			# Initial mask
	
firstDigits:
	and $t1, $s0, $t0			# Extract the bit of the first number
	beqz $t1, remZero			# Determine if the bit 0, if so print 0
	li $a0, 1				# Otherwise the bit is 1, when printing its 1
	j printFirst				# Retrieve the first number
	
remZero:
	li $a0, 0				# Print 0 for the bit 
	
printFirst:
	li $v0, 1				# Print the integer bits
	syscall
	srl $t0, $t0, 1				# Move the mask to right logically by 1
	bnez $t0, firstDigits			# Keep shifting the mask if the bit is not 0
	li $v0, 4	
	la $a0, newLine				# Print new line
	syscall
	jr $ra					# Return the address after retrieving all the integer bits 
	
firstInput:
	li $v0, 4				# Print the following statement
	syscall
	li $v0, 5				# Retrieve the user's input
	syscall
	jr $ra					# Return the address after getting the user's input
	
	
secondBinary:
	li $t2, 0x80000000			# Initial mask
	
secondDigits:
	and $t3, $s1, $t2			# Extract the bit of the second number
	beqz $t3, remZero2			# If the bit is 0, then print 0
	li $a0, 1				# Otherwise the bit is 1, so then print 1
	j printSecond				# Retrieve the digits for the second number in terms of binary
	
remZero2:
	li $a0, 0				# Print 0 for the bit
	
printSecond:
	li $v0, 1				# Print the integer bits
	syscall
	srl $t2, $t2, 1				# Move the mask to the right logically by 1
	bnez $t2, secondDigits			# Keep shifting the mask if the bit is not 0
	li $v0, 4
	la $a0, newLine				# Print a new line
	syscall
	jr $ra					# Return the address after getting all the integer bits in binary
	
secondInput:
	li $v0, 4				# Print the following statement above
	syscall
	li $v0, 5				# Retrieve the user's input for the second number
	syscall
	jr $ra					# Return the address after getting the user's input for the second number
	
	
adding:
	li $a0, 0
	li $a1, 0
	
	and $s0, $a0, $a1
	not $a0, $a1
	beq $s0, 1, adding	
	beq $a1, $s1, adding
	  
	beq $a0, $zero, adding
	
returnSum:
	li $s1, 0
	
#sumBinary:
	#li $s3, 0x80000000			# Initial mask
	
#sumDigits:
	#and $s4, $s2, $s3			# Extract the bits of the sum for two numbers
	#beqz $s4, sumRem			# If the bit is 0, then print 0
	#li $a0, 1				# Otherwise the bit is 1, then print 1
	#j printSum				# Retrieve the bits of the sum for two numbers
	
#sumRem:
	#li $a0, 0				# Print 0 for the bit
	
#printSum:
	#li $v0, 1				# Print the integer bits for the sum
	#syscall
	#srl $s3, $s3, 1				# Move the mask to right logically by 1
	#bnez $s3, sumDigits			# Keep shifting the mask until the bit is 0
	#li $v0, 4
	#la $a0, newLine				# Print a new line
	#syscall
	jr $ra					# Return the address after getting all the integer bits for the sum
	
firstHex:
	li   $t4, 0xf      		# Initial mask (hex address)
	sll  $t4, $t4, 28
	li   $t6, 28			# loop3i counter and shift amount	li $t6, 8
	
hexExtract:
	and   $t5, $s0, $t4			# Extract the bits for the first number
	srlv  $t5, $t5, $t6
	move  $a0, $t5
	
	subi  $t7, $t5, 9
	blt $t7, $zero, printDigits
	j printAlphas		# Get the bits for the second hex number
printDigits:	
	addi $a0, $a0, 48
	j printHex	
printAlphas:
        addi $a0, $a0, -10
	addi $a0, $a0, 97
		
printHex:
	la $t8, writeChar				
	sw $a0, 0($t8)
	sw $zero, 4($t8)
	li $v0, 4
	la $a0, writeChar
	syscall
	addi $t6, $t6, -4	
	srl  $t4, $t4, 4			# Move the mask to the right logically by 1
	bnez $t4, hexExtract			# Keep shifting the mask if the bit is not 0
	li   $v0, 4
	la   $a0, newLine				# Print a new line
	syscall
	jr   $ra					# Return address after getting all integer bits for the first hex number 

secondHex:
	li   $t4, 0xf      		# Initial mask (hex address)
	sll  $t4, $t4, 28
	li   $t6, 28			# loop3i counter and shift amount	li $t6, 8
	
hexExtract2:
	and   $t5, $s1, $t4			# Extract the bits for the first number
	srlv  $t5, $t5, $t6
	move  $a0, $t5
	
	subi  $t7, $t5, 9
	blt $t7, $zero, printDigits2
	j printAlphas2		# Get the bits for the second hex numberd hex number
	
printDigits2:	
	addi $a0, $a0, 48
	j printHex2	
printAlphas2:
        addi $a0, $a0, -10
	addi $a0, $a0, 97			# Print 0 for the bit

printHex2:
	la $t8, writeChar				
	sw $a0, 0($t8)
	sw $zero, 4($t8)
	li $v0, 4
	la $a0, writeChar
	syscall
	addi $t6, $t6, -4	
	srl  $t4, $t4, 4			# Move the mask to the right logically by 1
	bnez $t4, hexExtract2			# Keep shifting the mask if the bit is not 0
	li   $v0, 4
	la   $a0, newLine				# Print a new line
	syscall
	jr   $ra					# Return address after getting all integer bits for the first hex number 
sumHex:
	li   $t4, 0xf      		# Initial mask (hex address)
	sll  $t4, $t4, 28
	li   $t6, 28			# loop3i counter and shift amount	li $t6, 8
	
sumExtract:
	and   $t5, $s2, $t4			# Extract the bits for the first number
	srlv  $t5, $t5, $t6
	move  $a0, $t5
	
	subi  $t7, $t5, 9
	blt $t7, $zero, printDigits3
	j printAlphas3		# Get the bits for the second hex numberd hex number
	
printDigits3:	
	addi $a0, $a0, 48
	j printExtract
printAlphas3:
        addi $a0, $a0, -10
	addi $a0, $a0, 97			# Print 0 for the bit	# Print 0 for the bit
	
printExtract:
	la $t8, writeChar				
	sw $a0, 0($t8)
	sw $zero, 4($t8)
	li $v0, 4
	la $a0, writeChar
	syscall
	addi $t6, $t6, -4	
	srl  $t4, $t4, 4			# Move the mask to the right logically by 1
	bnez $t4, sumExtract			# Keep shifting the mask if the bit is not 0
	li   $v0, 4
	la   $a0, newLine				# Print a new line
	syscall
	jr   $ra					# Return address after getting all integer bits for the first hex numb


sumNumbers:

doWhileLoop:
	and  $s3, $s1, $s2
	
	and  $t7, $s1, $s2
	not  $t7, $t7
	
        and $t8, $s1, $t7
        not $t8, $t8
        
        and $t9, $s2, $t7
        not $t9, $t9
        
        and $s4, $t8, $t9
        not $s4, $s4
                
 	bnez $s3, doWhileLoop  
 	
 	move $v0, $s4                

	jr $ra
