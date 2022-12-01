################### Data segment ##########################

.data

CharStr: .asciiz "AEZKLBXWZXYALKFKWZRYLAKWLQLEK"
ResultArray: .space 26 
ReturnMsg1: .asciiz "The most freq char: "
ReturnMsg2: .asciiz " ,Occurence count: "
EndCycleMsg: .asciiz "Do you want to run this program again?"
.text
.globl main

main:
	 		
		la $a0, CharStr
		li $t0,0 					# counter for check length loop
		jal loop_check_length #check the length of the string
		la $a0, CharStr
		la $a1, ResultArray
		
		beq,$t0,1,end_program_now # end program if in the string have only one letter
	 
 		
     subi $sp, $sp,4  # push $a1 to the stack 
     sw $a1 , ($sp)		#save ResultArray 
 
 		
     jal char_occurrences# jump to Procedure 1
 
     la $t9,($a0)  # save current CharStr
     la $t8,($v0) 	# save current ResultArray
 
     lw $a1,($sp)
     addi $sp,$sp ,4 
 
     move $t0, $v0 # the times that the most freq char appear in the string
     move $t1, $v1 # The most freq char
 
########################## Procedure 2 ##################################
     li $v0,4 ## print returnmsg1 in string
     la $a0,ReturnMsg1
     syscall 

     li $v0, 11 #print the char with most freq
     move $a0,$t0 
     syscall 
 
     li $v0,4    #print returnmsg2 in string
     la $a0,ReturnMsg2 
     syscall
 
     li $v0, 1    #print how much the char shows in the input
     move $a0,$t1 
     syscall  
 
######################### End Procedure 2 ##################################
     li   $a0, '\n'   # down row
     li   $v0, 11
     syscall
     
      
    jal store_address    # jump to procedure 3
			
			li $a0,'\n'  # down row
			li $v0,11
			syscall
			
			la $a0,($t9) # load the address of current CharStr for procedure 4
 			la $a1,($t8) # load the address of current ResultArrayfor procedure 4
    		jal delete  # jump to procedure 4
    		
			li $a0, '|'
			li $v0, 11
			syscall 
			
			li $v0,4   # print the string without the most freq char
			la $a0,CharStr
			syscall
			
			li $a0,'\n'  # down row
			li $v0,11
			syscall
			
			la $a0,EndCycleMsg # Ask the user if run procedure 1-4 again
			li $v0,50
			syscall
			beq $a0,0,main    # return to main to continue procedures 1-4 again if the user press Yes
			beq $a0,1,end_program_now # end program if the user press No
			beq $a0,2,end_program_now # end program if the user press Cancel


############################## Procedure 1 ##############################

char_occurrences: 

    move $t4, $a1

    li $t0,'A'   # initilize t0 to the letter A to iteration
    move $t1,$zero   # for loop index
    move $t6, $zero	 
    move $t7,$t0


# Start of the for loop (iterates over the A-Z chars)
for_loop:
    move $t2, $a0  #copy CharStr
    move $t5, $zero # reset the char occurrence count.


while_loop: 
    lb $t3 , ($t2) # save to $t3 the value of the address saved in $t2 (CharStr)
    beq $t3 , '\0' , end_while_loop # if ($t3 == null ) break; 

    addi $t2,$t2,1 # increment the current char address in order reading the next char.
    bne $t3, $t0, while_loop   # if ($t3 != $t0 )

    addi $t5,$t5,1 # else - increment the char occurrence by 1 . 
    j while_loop
    
    
end_while_loop:

    sb $t5,($t4)  # store the char occurrence count to $t5 
    blt $t5,$t6 , continue_for_loop

    move $t6,$t5 
    move $t7,$t0

continue_for_loop:

    addi $t4,$t4,1
    addi $t1,$t1,1 # increment the for loop index by 1 
    addi $t0,$t0,1
    blt $t1,26, for_loop

    move $v1,$t6
    move $v0,$t7

    jr $ra

############################## End Procedure 1 ##############################

############################## Procedure 3 ##############################
store_address:
    sw $ra,0($sp)  # save return point
    li   $s0, 0  # counter for letters between A-Z
for_loop_read_userInput:    

    bge  $s0, 26, end_program # counter for letters A-Z
    
print:        
    move $a0, $s0
    la   $a1, ResultArray
    jal print_Char_by_occurences#jump to print loop for letters
    

    add  $s0, $s0, 1 #increment counter for letters A-Z
    
    j   for_loop_read_userInput
    
end_program:

    lw $ra,0($sp) # return to main

    jr $ra 
		
			    
print_Char_by_occurences:

    move $t2, $a0       #index
    
    li   $t1, 'A'       #load to $t1 ord('A')
    add  $t1, $t1, $t2  #add to ord('A') index value which will give as the letter to be printed
    
    move $t0, $a1       #userInput
    add  $t0, $t0, $t2   #calculate address of userInput[index]
    lb   $t3, ($t0)       #load the value at the calculated address, 
                #which will be used to stop the for loop
    move $t5, $zero
    
    beq  $t3, 0, exit
    
for_loop1:
    bge  $t5, $t3, end_loop
    
print_char:
	 add  $t5, $t5, 1 
    move $a0, $t1
    li   $v0, 11
    syscall
    
       
    j for_loop1
                
end_loop:
    li   $a0, '\n'  # down row
    li   $v0, 11
    syscall 
    
    
exit:
   jr $ra    

############################## End Procedure 3 ##############################

############################## Procedure 4  ##############################
delete:
		subi $sp,$sp,4
		sw $ra,($sp)
		
		move $v0, $zero

delete_char_loop:
		lb $t0, ($a0)
		beq $t0,'\0', end_delete_char_loop
		
		bne $t0,$a1,skip_delete_char
		
		subi $sp,$sp,8
		sw $a0,($sp)
		sw $a1,4($sp)
		
		jal reduction
		
		lw $a0,($sp)
		lw $a1,4($sp)
		addi $sp,$sp,8
		
		j delete_char_loop
		
skip_delete_char:
		addi $a0,$a0,1
		addi $v0,$v0,1
		j delete_char_loop
		
end_delete_char_loop:
		lw $ra,($sp)
		addi $sp,$sp,4
		
		jr $ra
		
reduction:
		lb $t0,1($a0)
		sb $t0, ($a0)
		
		addi $a0,$a0,1
		bne $t0, '\0', reduction
		
		jr $ra
		
############################## End Procedure 3 ##############################
		
end_program_now:
		li $v0,10
		syscall
		      
########################## Check the length of the string ###################		      
		      
loop_check_length:
        lb $t1, ($a0) # load the content of the address stored in $a0
        beq $t1, $zero, exit    # branch if equal
                    # exit the program if $t0 == null 

        addi $t0, $t0, 1 # increment the loop counter
        addi $a0, $a0, 1 # go to next byte      

        j loop_check_length


