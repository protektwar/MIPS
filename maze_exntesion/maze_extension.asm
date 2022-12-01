.data
	file: .asciiz "input_large.txt"
	buffer: .space 2048
	
	victory_msg: .asciiz "You won!"
	
	blue: .word 0x0000ff
	black: .word 0x000000
	yellow: .word 0xffff00
	green: .word 0x00ff00
	red: .word 0xff0000
	white: .word 0xffffff
	
	visited: .space 1024  
	
.text
##################
# BUILD THE MAZE #
#################
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
	
	move $s7, $gp # saving gp in a register as it is gonna be overwritten later on
	
	jal character_loop
	
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
	
	character_loop:
	###loops over each character in the buffer###
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
	
	beq $t3, $zero, reset_gp # nothing left in the buffer so we can close it
	
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
		
	reset_gp:
		move $gp, $s7  # loading back the original gp
		j game_loop

#####################
# HELPER FUNCTIONS #
###################
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
	
	li $t3, 32
	mul $t2, $t1, $t3 # r=y*width
	
	add $t2, $t2, $t0 # r=y*width + x
	
	sll $t2, $t2, 2 # r=y*width + x *4
	
	add $t2, $t2,  $gp
	
	move $v0, $t2
	
	move $s6, $v0
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra

search_element:
	# searches for the element in the visited array
	#parameters: $a0=address of the array, $a1=element to search for
	move $t0, $a0 #address of the array
	move $t1, $a1 # element to search for
	j loop_through_array
	
loop_through_array:
	addi $t0, $t0, 4 # increment the address
	lb $t2, ($t0) # load the value of that address
	beq $t2, $zero, not_found # break if we've reached the end of the vector
	beq $t2, $t1, found
	j loop_through_array
	
found:
	li $v0, 1 # return True
	jr $ra
	
not_found:
	li $v0, 0 # return False
	jr $ra

##############
# MOVEMENT #
#############
update_player_pos:
	### takes in the old coordinates ($a2, $a3) and new coordinates ($a0, $a1) and returns the new position if valid ###
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
	
	addi $t7, $t7, 1 # increment the offset
	sb $s6, visited($t7) # store $s6 in the visited vector
	
	lw $t4, -4 ($s6) # $t4 now contains the color of that pixel
	
	beq $t4, 0x0000ff, dfs # if the new pos is a wall, we try the next direction
	
	move $s4, $a0 # updating the player's x-pos in $s4
	move $s5, $a1 # updating the player's y-pos in $s5
	
	lw $t3, yellow
	sw $t3, -4($s6)
	
	move $a0, $a2
	move $a1, $a3
	
	jal conversion # $s6 now contains the address of the old pos
	
	lw $t3, black 
	sw $t3, -4($s6) # making the old pos a passage again
	
	beq $t4, 0x00ff00, victory

	j game_loop
	


######################	
# MANAGES THE GAME #	
#####################
game_loop:
	dfs:
	# uses depth first search algorithm to go through every passage in the maze until it finds the exit
	# parameters: $a0=current_col, $a1=current_row
	# this loops break gets handled by update_player_pos
		try_up:
		# try up first
		move $a0, $s4 #  keep the same column
	    subi $a1, $s5, 1 # decrement the row decrement the row
		jal conversion # get the address of the pixel
		la $a0, visited # load the address of the array
		move $a1, $s6 # move the address of the pixel
		jal search_element # check if the element has already been visited
		beq $v0, 0, up # $v0=0 if the pixel has not yet been visited
		
		try_left:
		# if we can't go up, try going left
		move $a0, $s4 #  keep the same column
	    subi $a1, $s5, 1 # decrement the row decrement the row
		jal conversion # get the address of the pixel
		la $a0, visited # load the address of the array
		move $a1, $s6 # move the address of the pixel
		jal search_element # check if the element has already been visited
		beq $v0, 0, up # $v0=0 if the pixel has not yet been visited
		
		try_down:
		# if we can't go left, try going down
		move $a0, $s4 #  keep the same column
	    subi $a1, $s5, 1 # decrement the row decrement the row
		jal conversion # get the address of the pixel
		la $a0, visited # load the address of the array
		move $a1, $s6 # move the address of the pixel
		jal search_element # check if the element has already been visited
		beq $v0, 0, up # $v0=0 if the pixel has not yet been visited
		
		try_right:
		#if we can't go down, try going right
		move $a0, $s4 #  keep the same column
	    subi $a1, $s5, 1 # decrement the row decrement the row
		jal conversion # get the address of the pixel
		la $a0, visited # load the address of the array
		move $a1, $s6 # move the address of the pixel
		jal search_element # check if the element has already been visited
		beq $v0, 0, up # $v0=0 if the pixel has not yet been visited
		
		go_back:
		# if we still haven't moved, means we've reached a dead end, now what?
		
		
	up:
		# up means decrement the row but keep the same column
	    move $a0, $s4
	    subi $a1, $s5, 1
	
	    j take_action # the new positions have been determined (they're used as arguments $a0, $a1 for take_action)
		    
	left:
	    # left means decrement the column but keep the same row
	    subi $a0, $s4, 1
	    move $a1, $s5
	
	    j take_action # the new positions have been determined (they're used as arguments $a0, $a1 for take_action)
	    
	down:
	    # down means increment the row but keep the same column
	    move $a0, $s4
	    addi $a1, $s5, 1
	
	    j take_action # the new positions have been determined (they're used as arguments $a0, $a1 for take_action)	
	    
	right:
		# right means increment the column but keep the same row
	    addi $a0, $s4, 1
	    move $a1, $s5
	
	    j take_action # the new positions have been determined (they're used as arguments $a0, $a1 for take_action)
			
#  b) take action
	take_action:
		# $a0 and $a1 contain the new pos
		move $a2, $s4 # current x-pos
		move $a3,  $s5 # current y-pos
		
		j update_player_pos
		
#  c) display victory
	victory:
		li $v0, 4
		la $a0, victory_msg
		syscall
		
		j exit
		
exit:
	li $v0, 10
	syscall
