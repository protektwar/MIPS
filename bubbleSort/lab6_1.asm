#==================================================================================#
# DATA - DO NOT MODIFY
.data 
	A:			.space 2000  	# create string array with 20 elements * 100 char per element ( A[20][100] )
	num_strings_prompt: 	.asciiz		"Enter array size [between 1 and 20]: "
	print_prompt:		.asciiz		"The sorted array of strings is...\n"
	array_start:		.asciiz		"A["
	array_end:		.asciiz		"] = "
#==================================================================================#	
	
.text
#==================================================================================#
# SCANNING IN INPUTS - DO NOT MODIFY
main: 
  	
	add $s1, $0, $0			# Initialize variable "size" ($s1) and set to 0.
	add $t0, $0, $0			# Initialize variable "i" ($t0) and set to 0.
	add $t1, $0, $0			# Initialize variable "j" ($t1) and set to 0.	
	add $t2, $0, $0			# Initialize variable "offset " (t2) and set to 0.

	addi $v0, $0, 4  			# System call (4) to print string.
	la $a0, num_strings_prompt 		# Put string memory address in register $a0.
	syscall           			# Print string.
	
	addi $v0, $0, 5			# System call (5) to get integer from user and store in register $v0.
	syscall				# Get user input for variable "size".
	add $s1, $0, $v0			# Copy to register $s1, b/c we'll reuse $v0.


scan_loop:
	
	beq $t0, $s1, bubble_sort		# End loop if i == size ($t0 == $s1).
	
	addi $v0, $0, 4			# System call (4) to print string.
	la $a0, array_start			# Put string memory address in register $a0.
	syscall				# Print string.
	
	addi $v0, $0, 1			# System call (1) to print integer.
	add $a0, $0, $t0			# Put integer value in register $a0.
	syscall				# Print integer.
	
	addi $v0, $0, 4			# System call (4) to print string.
	la $a0, array_end			# Put string memory address in register $a0.
	syscall				# Print string.
	
	li $v0, 8				# System call (8) to scan in string from user and store in register $v0.
	la $a0, 0($t2)			# Read A[i] (stored at address $s0 and store in $a0.
	li $a1, 100 			# Max character allowance per string.
	syscall
	
	addi $t2, $t2, 100			# Increment address of $t2 to store next string.
	addi $t0, $t0, 1			# i = i+1
	
	j scan_loop
#==================================================================================#

# TO-DO
bubble_sort: 
#==================================================================================#
# Perform bubble sort such that strings are ordered alphabetically by ASCII value.

# YOUR CODE HERE

#==================================================================================#

#==================================================================================#
# TO-DO:
lab_compare_strings:
	# $a0 = Starting address of A[j]
	# $a1 = Starting address of A[j+1]
	# $v0 = Return value of procedure (-1, 0, or 1).
#==================================================================================#
# This procedures switches the contents of two elements of your array. For example,
# if the string starting at $a0 = "hello" and the string starting at $a1 = "goodbye",
# then lab swap strings($a0, $a1) will result in the string starting at address $a0 =
# "goodbye" and the string starting at address $a1 = "hello".

# YOUR CODE HERE

#==================================================================================#


#==================================================================================#
# TO-DO:
lab_swap_strings:
	# $a0 = Starting address of A[j]
	# $a1 = Starting address of A[j+1]
# This procedures switches the contents of two elements of your array. For example,
# if the string starting at $a0 = "hello" and the string starting at $a1 = "goodbye",
# then lab swap strings($a0, $a1) will result in the string starting at address $a0 =
# "goodbye" and the string starting at address $a1 = "hello".

# YOUR CODE HERE

#==================================================================================#


#==================================================================================#
# OUTPUTTING RESULTS - DO NOT MODIFY
print:
		addi $t1, $0, 0		# Initialize variable "i" ($t1) and set to 0
		addi $t2, $0, 100		# Store 100 in $t2 for multiplicative factor.
		
		addi $v0, $0, 4		# System call (4) to print string.
		la $a0, print_prompt	# Put string memory address in register $a0.
		syscall			# Print string.
print_loop:
		beq $t1, $s1, exit		# We are done printing once we have printed the same number of strings as the size.
		
		addi $v0, $0, 4		# System call (4) to print string.
		la $a0, array_start		# Put string memory address in register $a0.
		syscall			# Print string.
	
		addi $v0, $0, 1		# System call (1) to print integer.
		add $a0, $0, $t1		# Put integer value in register $10.
		syscall			# Print integer.
	
		addi $v0, $0, 4		# System call (4) to print string.
		la $a0, array_end		# Put string memory address in register $a0.
		syscall			# Print string.
		
		
		mult $t1, $t2		# Multiply i by 100 to get appropriate address of A[i].
		mflo $a0			# Put memory address of A[i] in register $a0.
		li $v0, 4			# Print string.

		syscall 	

		addi $t1, $t1, 1 		# Increment i by 1.

	j print_loop

exit:
  	addi	$v0, $0, 10		# sys call 10 is for exit
  	syscall
#==================================================================================#