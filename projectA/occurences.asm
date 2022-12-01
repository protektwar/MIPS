.data 

userInput: .word 4,3,0,1,2,3,4,5,2,3,0,0,4,3,0,1,2,0,0,0,0,0,0,0,0,0

.text

main:
    
    li   $s0, 0
    
for_loop_read_userInput:    

    bge  $s0, 26, end_program
    
print:        
    move $a0, $s0
    la   $a1, userInput
    jal print_char_occurences
    

    add  $s0, $s0, 1
    
    j   for_loop_read_userInput
    
end_program:
        li $v0, 10
        syscall


print_char_occurences:
    move $t2, $a0       #index
    
    li   $t1, 'A'       #load to $t1 ord('A')
    add  $t1, $t1, $t2  #add to ord('A') index value which will give as the letter to be printed
    
    move $t0, $a1       #userInput
    mul  $t2, $t2, 4    #calculate position in userInput based on index value
    add  $t0, $t0, $t2   #calculate address of userInput[index]
    lw   $t3, ($t0)       #load the value at the calculated address, 
                #which will be used to stop the for loop
    move $t5, $zero
    
    beq  $t3, 0, exit
    
for_loop:
    bge  $t5, $t3, end_loop
    
print_char:
     move $a0, $t1
    li   $v0, 11
    syscall
    
    add  $t5, $t5, 1    
    j for_loop
                
end_loop:
    li   $a0, '\n'
    li   $v0, 11
    syscall 
    
exit:
    jr $ra