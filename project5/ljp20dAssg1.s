.data

name1: .asciiz "PTW\n" 
work: .asciiz "Read in three numbers and work with sum, difference, product, division and shifting.\n"
msg1: .asciiz "Enter the first number: " #prompt for all inputs and outputs
msg2: .asciiz "Enter the second number: "
msg3: .asciiz "Enter the third number: "
result: .asciiz "Sum: "
msg4: .asciiz "\nDifference: "
msg5: .asciiz "\nProduct: "
msg6: .asciiz "\nQuotient: "
msg7: .asciiz "\nRemainder: "
msgShifting1: .asciiz "\nThe results of shifting NUM1 by 1 binary digit: "
msgShifting2: .asciiz "\nThe results of shifting NUM2 by 2 binary digit: "
space: .asciiz " "
msg8: .asciiz "\n*** Warning the number is below 1. ***"
msg9: .asciiz "\nThe program has concluded, bye"
NUM1: .word 0
NUM2: .word 0
NUM3: .word 0

.text
main:

lw $t1, NUM1
la $t2, NUM2
la $t3, NUM3
li $t5, 1

li $v0,4
la $a0,name1 #The content of name1 variable will be printed
syscall

li $v0,4
la $a0,work #The content of work variable will be printed
syscall

li $v0,4
la $a0,msg1 #The content of msg1 variable will be printed
syscall

li $v0,5       #First Number input will be taken from user
syscall

slt $t4, $v0, $t5            # If 1 > $t7, $t4 is 1,
bne $t4, $zero, exitWithMsg      # if $t4 is 1, go to exit and print message8

sw $v0, 0($t1) #store the returned value at address of NUM1

li $v0,4
la $a0,msg2       #The content of msg2 variable will be printed
syscall

li $v0,5       #Second Number input will be taken from user
syscall

slt $t4, $v0, $t5            # If 1 > $t7, $t4 is 1,
bne $t4, $zero, exitWithMsg      # if $t4 is 1, go to exit and print message8

sw $v0, 0($t2) #store the returned value at address of NUM2

li $v0,4
la $a0,msg3       #The content of msg3 variable will be printed
syscall

li $v0,5       #Third Number input will be taken from user
syscall

slt $t4, $v0, $t5            # If 1 > $t7, $t4 is 1,
bne $t4, $zero, exitWithMsg      # if $t4 is 1, go to exit and print message8

sw $v0, 0($t3) #store the returned value at address of NUM3

lw $t1, NUM1
lw $t2, NUM2
lw $t3, NUM3

add $t4,$t1,$t2
add $t5,$t3,$t4       #addition

li $v0,4           #The prompt of addition will be printed
la $a0,result
syscall

li $v0,1           #The value of addition
move $a0,$t5
syscall


sub $t6,$t1,$t2      #subtraction

li $v0,4
la $a0,msg4           #The prompt of subtraction will be printed
syscall

li $v0,1           #The value of subtraction
move $a0,$t6      
syscall

mul $t7,$t1,$t2
mul $t8,$t7,$t3     #multiplication

li $v0,4           #The prompt of multiplication will be printed
la $a0,msg5
syscall

li $v0,1           #The value of multiplication
move $a0,$t8
syscall

div $t2,$t3    #division

li $v0,4           #The prompt of division will be printed
la $a0,msg6
syscall

li $v0,1
mflo $a0           #The value of division
syscall

li $v0,4           #The prompt of the remainder will be printed
la $a0,msg7
syscall


li $v0,1
mfhi $a0           #The value of remainder
syscall

lw $t1, NUM1
sll $t1, $t1, 1

lw $t2, NUM2
sll $t2, $t2, 2

lw $t3, NUM1
srl $t3, $t3, 1

lw $t4, NUM2
srl $t4, $t4, 2

li $v0,4           
la $a0,msgShifting1
syscall

li $v0,1          
move $a0,$t1
syscall

li $v0,4           
la $a0,space
syscall

li $v0,1         
move $a0,$t3
syscall

li $v0,4           
la $a0,msgShifting2
syscall

li $v0,1          
move $a0,$t2
syscall

li $v0,4           
la $a0,space
syscall

li $v0,1         
move $a0,$t4
syscall

li $v0,4           
la $a0,msg9
syscall

j exit

exitWithMsg:
li $v0,4
la $a0,msg8 #The content of msg8 variable will be printed
syscall

exit:
li $v0,10           #syscalling to finish of the program
syscall  
