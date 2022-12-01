.data
	file: .asciiz "input.txt"
	buffer: .space 2048
	
	blue: .word 0x0000ff
	black: .word 0x000000
	yellow: .word 0xffff00
	green: .word 0x00ff00
	red: .word 0xff0000
	white: .word 0xffffff
	
.text
main:
	j initialize
initialize:
### reads input file and draws maze###
    # read file to buffer
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	
	
	li $v0, 13 # get ready to open file
	la $a0, file
	li $a1, 0 # read only
	li $a2, 0 # ignore
	syscall
	
	move $s6, $v0 # the file descriptor
	
	li $v0, 14 # get ready to read from file
	move $a0, $s6 # load the file descriptor
	la $a1, buffer # address of buffer to which to load the contents
	li $a2, 2048 # 2048=max number of characters=size of the buffer
	syscall
	
	li $t1, 0 # t1 is the offset
	
	addi $t4, $zero, -1 # t4 = iterator
	addi $s2, $zero, 0 # s2 = column
	addi $s3, $zero, 0 # s3 = row
	
	jal character_loop
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
	
	character_loop:
	# ##loops over each character in the buffer###
	la $t2, buffer # loading the address of the buffer
	add $t2, $t2, $t1 # incrementing the address by the offset
	lb $t3, ($t2) # t3 is the next character in the buffer
	addi $t1, $t1, 1 # increment the offset
	
	mul $t5, $t1, 4 # t5 is the offset in bytes (rather than words)
	add $t6, $gp, $t5 # t6 is the next pixel
	addi $t0, $t0, 4 # setting the iterator to the next pixel too
	
	addi $s2, $s2, 1 # going to the next column
	
	beq $t3, 119, color_blue # w
	beq $t3, 112,  color_black # p
	beq $t3, 115, color_yellow # s
	beq $t3, 117,  color_green # u
	beq $t3, 10, next_line # \n
	beq $t3, 101,  color_red # e
	beq $t3, 99, color_white # c
	
	beq $t3, $zero, game_loop # nothing left in the buffer so we can close it
	
	j character_loop 
	

	#  put the right color in memory (in $t3)
	color_blue:
		lw $t3, blue
		j color
	color_black:
		lw $t3, black
		j color
	color_yellow:
		move $s4, $s2 # storing the player's x-pos in $s4
		move $s5, $s3 # storing the player's y-pos in $s5
		lw $t3, yellow
		j color
	color_green:
		lw $t3, green
		j color
	color_red:
		lw $t3, red
		j color
	color_white:
		lw $t3, white
		j color
	next_line:
		addi $s3, $s3, 1 # incrementing the row   
		li $s2, 0 # resetting the column
	
		subi $gp, $gp, 4 # go one pixel back
	
		j character_loop

	# draws the pixel with it's appropriate color
	color:
		sw $t3, -4($t6)
		j character_loop
	
update_player_pos:
	### takes in the old coordinates and new coordinates and returns the new position if valid ###
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)	
	
	move $t0, $a0 # new row
	move $t1, $a1 # new col
	move $t2, $a2 # cur row
	move $t3, $a3 # cur col
	
	jal conversion # $s6 now contains the address of the new pos
	
	lw $t4,  0($s6) # $t4 now contains the color of that pixel (in decimal for some reason)
	
	li $v0, 1
    move $a0, $t4
    syscall
	
	#beq $t4, blue, $ra # 255=blue, so if the new pos is a wall, we don't do anything
	
	
conversion: 
	### takes in a coordinate (x=$a0, y=$a1) and returns it's address in memory (in $s6) ###
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	
	move $t0, $a0 # x-coordinate
	move $t1, $a1 # y-coordinate
	
	lw $t3, 32
	mul $t2, $t1, $t3 # r=y*width
	
	add $t2, $t2, $t0 # r=y*width + x
	
	sll $t2, $t2, 2 # r=y*width + x *4
	
	add $t2, $t2, $gp # idk the pixel something
	
	move $v0, $t2
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	move $s6, $v0
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra

	
	
game_loop:
### manages the game ###

#  a ) check for input

#  b) take action
	take_action:
		la $a0, -4($s4)
		la $a1, ($s5)
		la $a2, ($s4) # current x-pos
		la $a3,( $s5) # current y-pos
		
		jal update_player_pos
		
#  c) check for victory

exit:
	li $v0, 10
	syscall
