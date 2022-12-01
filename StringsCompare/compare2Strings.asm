.data
a: .asciiz "abxd"
b: .asciiz "abcd"

.text

main:

la $t0, a
la $t1, b

li $t2, 0
li $t3,4     # string length
 
for_loop:
bge $t2, $t3, exit_loop
add $s1, $t2, $t0
add $s2, $t2, $t1

lb $t6, 0($s1)
lb $t7, 0($s2)

sne $t8, $t6,$t7
beq $t8,$0, write0

write1:
li $v0, 1
li $a0,1
syscall
j next

write0:
li $v0, 1
li $a0,0
syscall

next:
add $t2,$t2, 1
j for_loop
exit_loop:

end:
li $v0, 10
syscall