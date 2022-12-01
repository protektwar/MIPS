
.data

STR_ENTER: .asciiz "enter a string: "
ResultArray: .space 26 
ReturnMsg1: .asciiz "The most freq char: "
ReturnMsg2: .asciiz " ,Occurence count: "
buffer: .space 100

.text
.globl main

main: 
	la $a0, STR_ENTER    #print enter string
	li $v0, 4
	syscall
	li $v0,8    # read input
 	la $a0, buffer
 	li $a1, 100
 	move $a2, $a0
	syscall


 	la $a0, ($a2)
 	la $a1 , ResultArray
 
 	subi $sp, $sp,4  # push $a1 to the stack 
 	sw $a1 , ($sp)
 
 
 
 	jal char_occurrences
 
 	lw $a1,($sp)
 	addi $sp,$sp ,4 
 
 	move $t0, $v0
 	move $t1, $v1
 
 
 	li $v0,4 ## print returnmsg1 in string
 	la $a0,ReturnMsg1
 	syscall 

 	li $v0, 11 #print the char with most freq
 	move $a0,$t0 
 	syscall 
 
 	li $v0,4    #print returnmsg2 in string
 	la $a0,ReturnMsg2 
 	syscall
 
 	li $v0, 1    #print how much the char shows inthe input
 	move $a0,$t1 
 	syscall
 
        li   $a0, '\n'
        li   $v0, 11
        syscall
 
# 	li $v0,10
# 	syscall

	li   $s0, 0
    
for_loop_read_userInput:    

    bge  $s0, 26, end_program
    
print:        
    move $a0, $s0
    la   $a1, ResultArray
    jal print_char_occurences
    

    add  $s0, $s0, 1
    
    j   for_loop_read_userInput
    
end_program:
        li $v0, 10
        syscall
        		
# 	move $a0, $s0
#        la   $a1, ResultArray
#        jal print_char_occurences
 
# Char Occurrence count 
# 
#
#
#
#
#

char_occurrences: 

    move $s0, $a0 # $a0 = CharStr
    move $t4, $a1 

    li $t0,'A' 
    move $t1,$zero 
    move $t6, $zero
    move $t7,$t0


# Start of the for loop (iterates over the A-Z chars)
for_loop:
    move $t2, $a0 
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
	
	
print_char_occurences:

    move $t2, $a0       #index
    
    li   $t1, 'A'       #load to $t1 ord('A')
    add  $t1, $t1, $t2  #add to ord('A') index value which will give as the letter to be printed
    
#    lb $t0, ($a1)       #userInput
    move $t0, $a1       #userInput
#    mul  $t2, $t2, 4    #calculate position in userInput based on index value
    add  $t0, $t0, $t2   #calculate address of userInput[index]
    lb   $t3, ($t0)       #load the value at the calculated address, 
                #which will be used to stop the for loop
    move $t5, $zero
    
    beq  $t3, 0, exit
    
for_loop1:
    bge  $t5, $t3, end_loop
    
print_char:

    move $a0, $t1
    li   $v0, 11
    syscall
    
    add  $t5, $t5, 1    
    j for_loop1
                
end_loop:
    li   $a0, '\n'
    li   $v0, 11
    syscall 
    
exit:
    jr $ra

       
delete:
    move $t0, $a0  # string address
    move $t1, $a1  # character
    move $t2, $a2  # new string

    move $s0, 0 #string index
    move $s1, 0 #new string index

string_loop:
    move $s1, $s0      #prepare $s1 for element address calculation, it will be initialisez with index
    add  $s1, $s1, $t0 #add string base address to index
    lb $t2, ($s1)      #load string char from position calculated above
    beq $t2, $zero, end_string_loop  # if end of string end_string_loop

    beq $t2, $t1, skip_char
copy_char_to_new_string:
    move $s1, $s2      #prepare $s1 for element address calculation, it will be initialisez with index
    add  $s1, $s1, $t2 #add new string base address to index
    sb $t2, ($s1)      #store string char at position calculated above
    
    addi $s2, $s2, 1
    j string_loop_next
skip_char:

string_loop_next:
    addi $s0, $s0, 1 #increment index for next char position
    
end_string_loop:

    move $s1, $s2      #prepare $s1 for element address calculation, it will be initialisez with index
    add  $s1, $s1, $t2 #add new string base address to index
    li   $t2, '\0'     # end of String
    sb   $t2, ($s1)    #store end of string char at position calculated above

end_delete:
    jr   $ra
            
                    
