#############################################################	
#  This data block contains a 'digits' memory allocation
#  that you can use to store any strings that you convert
#  from integers.  Remember to either clear it after use or
#  null-terminate the strings that you save here!
#############################################################

.data
    digits:      .space     10


.text

.globl PROC_COUNT_FORMAT_SPECIFIERS
.globl PROC_CONVERT_INT_TO_STRING
.globl PROC_SPRINTF

.globl PROC_FIND_LENGTH_STRING
.globl PROC_FIND_NUM_DIGITS
.globl PROC_REVERSE_STRING
.globl PROC_CLEAR_DIGITS



	
#############################################################	
#  Given the address of a string, count the number of format 
#  specifiers that appear in that string
#
#  Pre:  $a0 contains the address of the string to evaluate
#  Post: $v0 contains the number of format specifiers that 
#          were found in the input string
#############################################################

PROC_COUNT_FORMAT_SPECIFIERS:    

    # add your solution here
    li $v0, 0 #count
    li $t0, 0 #i
    li $t5, '%'
    
    RunLoop:
    add $t1, $a0, $t0        #$t1 = String Address + index
    lb  $t2, 0($t1)          #load byte at address $t1
    beq $t2, $zero, EndLoop  #is end of string? jump EndLoop
    bne $t2, $t5, skip       #is != with '%'? skip counting
    addi $v0, $v0, 1         #was == with '%'? count

    skip:                    #skip label
    add $t0, $t0, 1          #increment string index
    j RunLoop                #jump RunLoop
    
    EndLoop:                 #EndLoop label
    # return 
    jr $ra

#############################################################	
#  Given an integer, convert it into a string
#
#  Pre:  $a0 contains the integer that will be converted
#  Post: $v0 contains the address of the newly-created string
#############################################################

PROC_CONVERT_INT_TO_STRING:
    addi $sp, $sp, -4
    sw $t0, ($sp)
j Next

Next:
    li $t0, -1
    li $t1, 0
    addi $sp, $sp, -4
    sw $t0, ($sp)
    
Push_Digits:
    blez $a0, Next1
    li $t0, 10
    div $a0, $t0
    mfhi $t0
    mflo $a0
    addi $sp, $sp, -4
    sw $t0, ($sp)
    add $t1, $t1, 1
    j Push_Digits
    
Next1:
    lw $t0, ($sp)
    addi $sp, $sp, 4
    j Digits                

Digits:     
    addi $t1, $t1, 1
    li $v0, 9
    move $a0, $t1
    syscall      
     
    li $t1,0
    
Pop_Digits:
    bltz $t0, next2           # if digit <= 0 goto next2 (end of loop)
    addi $t0, $t0, '0'        # else, $t0 = ASCII of digit
    add $t2, $t1, $v0
    sb   $t0, ($t2)           # *str = ASCII of digit
    addi $t1, $t1, 1          # str++
    lw   $t0, ($sp)           # digit = pop off from MIPS stack 
    addi $sp, $sp, 4          # restore stack
    j    Pop_Digits           # and loop
    
next2:
    add $t2, $t1, $v0
    sb  $zero, ($t2)          # *str = 0 (end of string marker)

    lw   $t0, ($sp)           # restore $t0 value before function was called
    addi $sp, $sp, 4          # restore stack

    # return 
    jr $ra  

#############################################################	
#  Given the address of a string and a string which may or 
#  may not include format specifiers, write a formatted 
#  version of the string into the output register $v0
#
#  Pre:  $a0 contains the address of the string dest, where
#          the final string will be written into
#        $a1 contains the address of a format string, which 
#          may or may not include format specifiers, and which 
#          details the required final state of the output 
#          string
#        $a2 contains an unsigned integer or the address of
#          a string, or it is empty
#        $a3 contains an unsigned integer or the address of
#          a string, or it is empty
#  Post: $a0 contains the address of the formatted dest, 
#          including null terminator
#        $v0 contains the length of the string written into
#          dest, not including null terminator
#############################################################

PROC_SPRINTF:


    # add your solution here
    li $v0, 0 #count
    li $t0, 0 #i
    li $t4, 0
    li $t5, '%'
    li $t6, 's'
    li $t7, 'u'
    li $s0, 0
    
    RunLoops:
    add $t1, $a1, $t0 
    lb  $t2, 0($t1) 
    beq $t2, $zero, EndLoops  
    bne $t2, $t5, next
    addi $v0, $v0, 1   # I'm not sure what this is used for... 
    addi $s0, $s0, 1   #let use $s0 for % counter

    beq $s0, 1, param_a2   # $a2 will be used as string replacement for %s
    beq $s0, 2, param_a3   # $a3 will be used as string replacement for %s
    j skips                     # none matches 
param_a2:
    move $s1, $a2 
    j param_done
param_a3:
    move $s1, $a3
    # j param_done is not needed

param_done:
    add $t0, $t0, 1  
    add $t1, $a1, $t0 
    lb  $t2, 0($t1) 

    beq $t2, $t6, add_string
    beq $t2, $t7 add_int 

add_string:
    li $t3, 0 #index for the string that will be copied

string_loop:
    add $s4, $s1, $t3 # $s1 address of string to be used
                      # $t3 index
                      # $s4 calculated address
    add $s5, $a0, $t4 # $a0 address of new string
                      # $t4 index
                      # $s5 calculated address
    lb  $s2, 0($s4) 
    sb  $s2, 0($s5)
    beq $s2, $zero, string_loop_end  

    #here you should increment the counter for the new string
    addi $t4,$t4,1
    addi $t3, $t3, 1
    
    j string_loop

string_loop_end:

    j skips
    
add_int:
    subi $sp, $sp, 4
    sw $a0, 0($sp)

    subi $sp, $sp, 4
    sw $ra, 0($sp)

    move $a0, $s1
    jal PROC_CONVERT_INT_TO_STRING

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    lw $a0, 0($sp)
    addi $sp, $sp, 4

    move $s1, $v0
    j add_string

next:      
    # add char to the new string
    #here you should increment the counter for the new string
    add $s5, $a0, $t4 # $a0 address of new string
                      # $t4 index
                      # $s5 calculated address
    sb  $t2, 0($s5)

    addi $t4,$t4,1
skips: 
    add $t0, $t0, 1  
    j RunLoops
    
EndLoops:
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    #$a0 has the right address
    jal PROC_FIND_LENGTH_STRING

    lw $ra, 0($sp)
    addi $sp, $sp, 4
        
    jr $ra

#############################################################	
#  This procedure will find the length of a provided string
#  by counting characters until the null terminator is 
#  reached
#
#  Pre:  $a0 contains the string to evaluate
#  Post: $v0 contains the length of the string
#############################################################

PROC_FIND_LENGTH_STRING:	
	
	# prologue
	
	# function body
	move $t2, $a0			# $t2 is the current char we're pointing to
	li $t4, 0			# $t4 is my length counter for my_string

	# Loop until we find the null terminator
    LOOP_FIND_NULL_BYTE_LENGTH:	
	lb $t1, 0($t2)			# $t1 is the character loaded from offset $t2
	beq $t1, $zero, FOUND_NULL_BYTE_LENGTH
	
	addi $t4, $t4, 1		# increment length counter
	addi $t2, $t2, 1		# increment character pointer
	
	j LOOP_FIND_NULL_BYTE_LENGTH
	
    FOUND_NULL_BYTE_LENGTH:	
	# at this point, $t2 is pointed at \0
	move $v0, $t4
	
	# epilogue
	
	# return 
	jr $ra
	
#############################################################	
#  This procedure will determine the number of digits in the
#  provided integer input via iterative division by 10.
#
#  Pre:  $a0 contains the integer to evaluate
#  Post: $v0 contains the number of digits in that integer
#############################################################	

PROC_FIND_NUM_DIGITS:

	# prologue
	
	# function body
	li $t0, 10      # load a 10 into $t0 for the division
	li $t5, 0       # $t5 will hold the counter for number of digits
	move $t6, $a0   # $t6 will hold the result of the iterative division

    NUM_DIGITS_LOOP:
        divu $t6, $t0   # divide the number by 10
        addi $t5, $t5, 1
        
        mflo $t6       # move quotient back into $t6
        beq $t6, $zero, FOUND_NUM_DIGITS    # if the quotient was 0, $t5 stores the number of digits
        j NUM_DIGITS_LOOP


    FOUND_NUM_DIGITS:
        move $v0, $t5   # copy the number of digits $t5 into $v0 to return
	
	# epilogue
	
	# return 
	jr $ra		
	
#############################################################	
#  This procedure will reverse the characters in a string in-
#  place when given the addresses of the first and last
#  characters in the string.
#
#  Pre:  $a0 contains the address of the first character
#        $a1 contains the address of the last character
#  Post: $a0 contains the first character of the reversed
#          string
#############################################################

PROC_REVERSE_STRING:

	# prologue

	# function body	
	move $t0, $a0                  # move the pointer to the first char into $t0
	move $t2, $a1	               # move the pointer to the last char into $t2
					
	# Loop until the pointers cross	
LOOP_REVERSE:	
	lb $t9, 0($t2)			# backing up the $t2 position char into $t9
	lb $t8, 0($t0)			# load the $t0 position char into $t8
	
	sb $t8, 0($t2)			# write the begin char into $t2 position
	sb $t9, 0($t0)			# write the end char into $t0 position
	
	# increment and decrement the pointers
	addi $t0, $t0, 1
	subi $t2, $t2, 1
	
	ble $t2, $t0, END_OF_REVERSE_LOOP
	j LOOP_REVERSE

END_OF_REVERSE_LOOP:
	
	# epilogue
	
	# return 
	jr $ra


#############################################################	
#  This procedure will clear the contents of the 'digits'
#  memory allocation that is defined in the data block of 
#  this file.
#
#  Pre:  None
#  Post: The 'digits' section of memory is cleared to all 0s
#############################################################
	
PROC_CLEAR_DIGITS:	

	# prologue
	
	# function body
	la $t0, digits    # get the address of the digits space
	li $t1, 10        # we need to loop 10 times
	li $t2, 0         # and the loop counter starts at 0
	
    CLEAR_LOOP:	
        sb $zero, 0($t0)  # write all zeros into #t0
        addi $t0, $t0, 1  # move to the next char space
        addi $t2, $t2, 1  # increment loop counter
        
        beq $t2, $t1, END_CLEAR   # break out of the loop after 10 writes
        j CLEAR_LOOP
        
    END_CLEAR:	

	# epilogue

	# Return
	jr $ra		
	
#############################################################		
