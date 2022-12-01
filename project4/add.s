	
.text		
       	

main:

#Print Prompt1	"Enter the first integer"
la $a0,prompt1	
# print prompt on terminal
li $v0,4	
syscall

#read an integer and put it in v0	
li $v0,5	
# syscall 5 reads an integer
syscall

#move value in v0 to t0	
add $t0,$v0, $zero

#print prompt2 "Enter the second integer"
la $a0,prompt2	
# print prompt on terminal
li $v0,4
syscall

#read an integer into v0	
li $v0,5	
# syscall 5 reads an integer
syscall

#move value in v0 to t1		
add  $t1,$v0, $zero

#add t0 with t1 and put the result in t2
add $t2,$t0,$t1	# add 

#mul $t2 with 2, in order to find out perimeter
mul $t2, $t2, 2

#mul $t0 with t1 and put the result in $t3
mul $t3, $t0, $t1

#print area "Area is "	
la $a0,area	# print string before result
li $v0,4	
syscall

#print result of addition	
move $a0,$t3	# move result to a0
li $v0,1	
syscall

#print newline
la $a0,endl	# system call to print
li $v0,4	
# out a newline
syscall

#print area "Perimeter is "	
la $a0,perimeter	# print string before result
li $v0,4	
syscall

#print result of addition	
move $a0,$t2	# move result to a0
li $v0,1	
syscall

#print newline
la $a0,endl	# system call to print
li $v0,4	
# out a newline
syscall

#terminate
li $v0,10
syscall		
# au revoir...

	
.data

prompt1:.asciiz "Enter width: "

prompt2:.asciiz "Enter height: "

area:	.asciiz "Area is "

perimeter: .asciiz "Perimeter is "

endl:.asciiz "\n"


##
## end of file temp.s
