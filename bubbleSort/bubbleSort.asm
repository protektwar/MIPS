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
	add $t2, $0, $0                	# Initialize variable "offset " (t2) and set to 0.

	addi $v0, $0, 4  			# System call (4) to print string.
	la $a0, num_strings_prompt 		# Put string memory address in register $a0.
	syscall           			# Print string.
	
	addi $v0, $0, 5			# System call (5) to get integer from user and store in register $v0.
	syscall				# Get user input for variable "size".
	add $s1, $0, $v0			# Copy to register $s1, b/c we'll reuse $v0.


scan_loop:
	
	beq $t0, $s1, bubble_sort		# End loop if i == size ($t0 == $s1).
#	beq $t0, $s1, print		# End loop if i == size ($t0 == $s1).
	
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
	move $a0, $t2			# Read A[i] (stored at address $s0 and store in $a0.
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

# t := $t0
# i := $t1
# size - 1 == $t2
# Initialize variables (t = 0, i = 0, $t2 = size - 1)
    li $t0, 0
    li $t1, 0
    addi $t2, $s1, -1
for1:
    # Check for loop condition (i < $t2), break if false
    slt $t8, $t1, $t2
    beq $t8, $0, endfor1
    # j := $t3
    # size - 1 - i = $t4
    # Initialize variables for inner loop (j = 0, $t4 = size - 1 - i)
    li $t3, 0
    sub $t4, $s1, $t1
    addi $t4, $t4, -1
for2:
    # Check inner loop conditions (j < $t4), break if false
    slt $t8, $t3, $t4
    beq $t8, $0, endfor2
    # $t5 := A[j]
    # $t6 := A[j + 1]
    mul $t5, $t3, 100
    add $t6, $t5, 100
    
    move $a0, $t5                       # param 1 address of A[j]
    move $a1, $t6                       # param 2 address of A[j+1]
    jal lab_compare_strings
    
    beq $v0, 1, swap_them              #           if ( A[j] > A[j+1] ) {
    
    j do_not_swap
    
swap_them:
    move $a0, $t5                       # param 1 address of A[j]
    move $a1, $t6                       # param 2 address of A[j+1]
    jal lab_swap_strings
    
do_not_swap:     
    # j++ for the inner loop
    addi $t3, $t3, 1
    j for2
endfor2:
    # i++ for the outer loop
    addi $t1, $t1, 1
    j for1
endfor1:

    j print
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

   addi $sp, $sp, -8                       #stack compare strings
   sw $ra, 4($sp)
   sw $fp, 0($sp)
   addi $fp, $sp, 4

   addi $sp, $sp, -36
   sw $t0, 32($sp)
   sw $t1, 28($sp)
   sw $t2, 24($sp)
   sw $t3, 20($sp)
   sw $t4, 16($sp)
   sw $t5, 12($sp)
   sw $t6, 8($sp)
   sw $t7, 4($sp)
   sw $t8, 0($sp)
      
   
   addi $t0, $0, 0          # string element index
   move $t1, $a0            #load address of A[j]   in $t1
   move $t2, $a1            #load address of A[j+1] in $t2
   addi $s0, $v0, 99       #load 100 to $s0

for_compare_strings:

        beq $t0, $s0, for_compare_strings_end    # we are done cycling through the strings 
        add $t3, $t0, $t1
        add $t4, $t0  $t2
        lb $t5, 0($t3)
        lb $t6, 0($t4)
        
        slt $t8, $t5, $t6
        beq $t8, 1, return_smaller
        
        slt $t8, $t6, $t5 
        beq $t8, 1, return_greater
        
        addi $t0, $t0, 1 		# Increment i by 1.
	j for_compare_strings
                        
for_compare_strings_end:

   j return_equal
         
   
return_smaller:                         # strA < strB 
   addi $v0, $0, -1                     # return -1
   j end_lab_compare_strings
   
return_greater:                         # strA > strB
   addi $v0, $0, 1                      # return 1
   j end_lab_compare_strings
   
return_equal:                           # strA == strB
   addi $v0, $0, 0                      # return 0
   
end_lab_compare_strings: 

   lw $t8, -40($fp)
   lw $t7, -36($fp)
   lw $t6, -32($fp)
   lw $t5, -28($fp)
   lw $t4, -24($fp)
   lw $t3, -20($fp)
   lw $t2, -16($fp)
   lw $t1, -12($fp)
   lw $t0, -8($fp)

   addi $sp, $fp, 4
   lw $ra, 0($fp)
   lw $fp, -4($fp)

   jr $ra
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

   addi $sp, $sp, -8                       #stack swap strings
   sw $ra, 4($sp)
   sw $fp, 0($sp)
   addi $fp, $sp, 4

   addi $sp, $sp, -40
   sw $s0, 36($sp)
   sw $t0, 32($sp)
   sw $t1, 28($sp)
   sw $t2, 24($sp)
   sw $t3, 20($sp)
   sw $t4, 16($sp)
   sw $t5, 12($sp)
   sw $t6, 8($sp)
   sw $t7, 4($sp)
   sw $t8, 0($sp)

   addi $t0, $0, 0          # string element index
   move $t1, $a0            #load address of A[j]   in $t1
   move $t2, $a1            #load address of A[j+1] in $t2
   addi $s0, $v0, 99       #load 100 to $s0

for_swap_strings:

        beq $t0, $s0, for_swap_strings_end    # we are done cycling through the strings 
        add $t3, $t0, $t1
        add $t4, $t0  $t2
        lb $t5, 0($t3)
        lb $t6, 0($t4)
        
        move $t7, $t5
        move $t5, $t6
        move $t6, $t7
        
        sb $t5, 0($t3)
        sb $t6, 0($t4)
        
        addi $t0, $t0, 1 		# Increment i by 1.
	j for_swap_strings
                        
for_swap_strings_end:

   lw $t8, -44($fp)
   lw $t7, -40($fp)
   lw $t6, -36($fp)
   lw $t5, -32($fp)
   lw $t4, -28($fp)
   lw $t3, -24($fp)
   lw $t2, -20($fp)
   lw $t1, -16($fp)
   lw $t0, -12($fp)
   lw $s0, -8($fp)

   addi $sp, $fp, 4
   lw $ra, 0($fp)
   lw $fp, -4($fp)
   jr $ra
#==================================================================================#

#==================================================================================#
# OUTPUTTING RESULTS - DO NOT MODIFY
print:
		addi $t1, $0, 0		# Initialize variable "i" ($t1) and set to 0
		addi $t2, $0, 100		# Store 100 in $t2 for multiplicative factor.
		la   $t3, A
		
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
