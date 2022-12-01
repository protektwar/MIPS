# larger.s-- prints the larger of two numbers specified
# at runtime by the user.
# Registers used:
# $t0 - used to hold the first number.
# $t1 - used to hold the second number.
# $t5 - used to hold the 3rd number.
# $t2 - used to store the larger of $t1 and $t2.
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.text

main:
## Get first number from user, put into $t0.
li $v0, 5             # load syscall read_int into $v0.
syscall             # make the syscall.
add $t0, $v0, $zero        # move the number read into $t0.

## Get second number from user, put into $t1.

li $v0, 5             # load syscall read_int into $v0.
syscall             # make the syscall.
add $t1, $v0, $zero        # move the number read into $t1.

li $v0, 5             # load syscall read_int into $v0.
syscall             # make the syscall.
add $t5, $v0, $zero        # move the number read into $t4.

#use t3 told maximum, let $t3=$t0 (assuming the first number is larger)
add $t3, $t0,$zero
## put the larger of $t0 and $t1 into $t3.

slt $t4, $t1, $t3         # If $t1 < max ($t3), $t4 is 1,
bne $t4, $zero,Next        # if $t4 is 1, go to Next because no need to change max
add $t3, $t1, $zero        #     other wise $t1<$t3 is not true, we need to set $t3 as $t1

Next:                       #At this point, $t3 holds larger value between $t0 and $t1

slt $t4, $t5, $t3         # If $t5 < max ($t3), $t4 is 1,
bne $t4, $zero,Next1        # if $t4 is 1, go to Next because no need to change max
add $t3, $t5, $zero        #     other wise $t5<$t3 is not true, we need to set $t3 as $t5

Next1:                       #At this point, $t3 holds larger value between $t0, $t1 and $t5

#print $t3 which is the maximum
add $a0, $t3, $zero        # move the number to print into $a0.
li $v0, 1             # load syscall print_int into $v0.
syscall             # make the syscall.

## exit the program.
li $v0, 10             # syscall code 10 is for exit.
syscall             # make the syscall.

# end of larger.s