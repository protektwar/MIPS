	.data

MSG1:	.asciiz		"Hello and Welcome!!!!!!!!"
MSG2:	.asciiz		"\nHow big do you want your matrix? Please enter between 2 and 6: "
ERR:	.asciiz		"\nInvalid value, please try again."
MTRXA:	.space		144
MTRXB:	.space		144
MTRXC:	.space		144
MSG3:	.asciiz		"\nEnter in matrix values one after another"
SPACE:  .asciiz		" "
NEW:	.byte		'\n'

	.text
	.globl	main
main:

	li	$v0,4
	la	$a0,MSG1
	syscall
GETN:
	la	$a0,MSG2	#ask for matrix size
	syscall
	
	li	$v0,5
	syscall			#get size, store in $t0
	move	$t0,$v0

 	blt	$t0,2,BADN
	bgt	$t0,6,BADN	#check for bad number

	move	$a1,$t0		#move $t0 to parameter 
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)	#allocate space
	jal	MTRX1		#go to matrix function to get marix values
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	
done:

        addiu   $sp,$sp,-4
        sw      $ra,0($sp)      #allocate space
        jal     MTRX2           #go to matrix function to get marix values
        lw      $ra,0($sp)
        addiu   $sp,$sp,4

done2:

	j 	PRINT1


	jr	$ra	

BADN:
	li	$v0,4
	la	$a0,ERR		#print error, go back to ask for size
	syscall
	j	GETN	

MTRX1:	
	li	$s1,0		#inner counter
	li	$s2,0		#outer counter
	move	$t0,$a1		#move parameter to $t0
	li	$t4,4		#col offset
	mul	$t1,$t0,4	#row offset
	la	$a1,MTRXA	#address of array
        li      $v0,4
        la      $a0,MSG3
        syscall	

TOPA:
	bge	$s2,$t0,ENDROWA	#check if counter has reached end of row
	mul	$t2,$s1,$t1	#multiply row offset by counter
	mul	$t3,$s2,$t4	#multiply col offset by counter
	add	$s4,$a1,$t2	#add offset to matrix address
	add	$s4,$s4,$t3
	li	$v0,4
	la	$a0,NEW
	syscall			#new line
	li	$v0,5
	syscall			#ask for matrix value
	sw	$v0,MTRXA($s4)	#store in matrix, ERROR HERE
	add	$s2,$s2,1	#add counter
	j	TOPA		#go to top of loop
ENDROWA:
	add	$s1,$s1,1	#add to row counter
	bge	$s1,$t0,done	#if row counter is done, finish loop
	li	$s2,0		#if not, reset col counter back
	j	TOPA		#go to top of loop

MTRX2:
        li      $s1,0
        li      $s2,0
        move    $t0,$a1
        li      $t4,4
        mul     $t1,$t0,4
        la      $a1,MTRXB
        li      $v0,4
        la      $a0,MSG3
        syscall

TOPB:
        bge     $s2,$t0,ENDROWB
        mul     $t2,$s1,$t1
        mul     $t3,$s2,$t4
        add     $s4,$a1,$t2
        add     $s4,$s4,$t3
        li      $v0,4
        la      $a0,NEW
        syscall
        li      $v0,5
        syscall
        sw      $v0,MTRXA($s4)
        add     $s2,$s2,1
        j       TOPB
ENDROWB:
        add     $s1,$s1,1
        bge     $s1,$t0,done2
        li      $s2,0
        j       TOPB

PRINT1:
        li      $s1,0           #inner counter
        li      $s2,0           #outer counter
        move    $t0,$a1         #move parameter to $t0
        li      $t4,4           #col offset
        mul     $t1,$t0,4       #row offset
        la      $a1,MTRXA       #address of array

TOPP1:
        bge     $s2,$t0,ENDROWP1#check if counter has reached end of row
        mul     $t2,$s1,$t1     #multiply row offset by counter
        mul     $t3,$s2,$t4     #multiply col offset by counter
        add     $s4,$a1,$t2     #add offset to matrix address
        add     $s4,$s4,$t3
        lw      $a0,MTRXA($s4)  #load num into print address
	li	$v0,1
	syscall
	li	$v0,4
	la	$a0,SPACE
	syscall
        add     $s2,$s2,1       #add counter
        j       TOPP1           #go to top of loop
ENDROWP1:
	li	$v0,4
	la	$a0,NEW
	syscall
        add     $s1,$s1,1       #add to row counter
        bge     $s1,$t0,done3    #if row counter is done, finish loop
        li      $s2,0           #if not, reset col counter back
        j       TOPP1           #go to top of loop
