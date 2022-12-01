## find s.
## Ask the user to enter a number or key, display whether it is in the array

#################################################
#                         #
#        text segment              #
#                        #
#################################################


.text

main:

#$t2 is used to hold the sum
li $t2, 0

li $t8,0    #initialize $t8 as 0, $t8 is like a flag. 
        #If it stays at 0, it means the number you try to search is not in the array

la $t0,array    # $t0 will has the address of the array "array" or it now points to the array

lw $t1,count    # initialize $t1 as count or 15

li $t5,0    # initialize t5 to 0, $t5 is used as array index i

Loop: 
slt $t6,$t5,$t1     #$t6 is 1 if $t5<count or i<15
beq $t6,$0,EndLoop    #if $t6 is 0, loop ends, skip many lines until EndLoop, next instruction is labled as EndLoop
            #first two lines are like while(i<15)
sll  $t6, $t5, 2    #starts the body of the loop, set $t6=4$t5 (4i)
add  $t6, $t0, $t6    #$t6=$t6+4*i, $t6 now holds address of array[i]
lw   $t7, 0($t6)    #load array[i] to register $t7


slt $t4, $t7, $zero      # If 0 > $t7, $t4 is 1,
bne $t4, $zero,Next      # if $t4 is 1, go to Next because no need to add

add $t2, $t2, $t7

Next:

addi $t5, $t5, 1    #if we can get here, it means we have not found the key in the array, increment $t5 (i)
j    Loop        #starts the next iteration

EndLoop:


la $a0,ans1        #Load address of "Sum="
li $v0,4        #tell OS to print a string
syscall            #OS prints out "Sum="

li $v0,1        #tell OS to print out the total
add $a0, $t2, $zero
syscall            #OS prints out the sum


li $v0,10        #terminate the program

syscall
# au revoir...

#################################################
#                         #
#              data segment            #
#                        #
#################################################


.data


array:    .word 8,12,13,-10,-12

count:    .word 5

endl:    .asciiz "\n"

ans1:    .asciiz "Sum= "


##
## end of file minmax.s