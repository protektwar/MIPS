
	        .data
redData:	.word   0:4
greenData:      .word   0:4
prmpt1:	 .asciiz "Enter x-coordinate for red particle (0 to 10):"
prmpt2:	 .asciiz "Enter y-coordinate for red particle (0 to 10):"
prmpt3:	 .asciiz "Enter x-coordinate for green particle (0 to 10):"
prmpt4:	 .asciiz "Enter y-coordinate for green particle (0 to 10):"
prmpt5:	 .asciiz "cycle "
prmpt6:	 .asciiz "red particle (x,y,xVel,yVel): "
prmpt7:	 .asciiz "green particle (x,y,xVel,yVel): "
prmpt8:	 .asciiz "Collison: oops, end of simulation!\n"
space:   .asciiz " "
endl:	 .asciiz "\n"

# i     $s0
# cycle $s1 = 0
# dist  $s2

	.text

main:	li      $s1,0

	la      $s3,redData     #  redData[2] = 1 ;
	li      $s4,1
	sw      $s4,8($s3)
	sw      $s4,12($s3)     #  redData[3] = 1 ;
	la      $s3,greenData   #  greenData[2] = -1 ;
	li      $s4,-1
	sw      $s4,8($s3)
	sw      $s4,12($s3)     #  greenData[3] = -1 ;

	la      $a0,prmpt1      #  cout << prmpt1 ;
	li      $v0,4
	syscall
	la      $s3,redData
	li      $v0,5           #  cin >> redData[0] ;
	syscall
	sw      $v0,($s3)
	la      $a0,prmpt2      #  cout << prmpt2 ;
	li      $v0,4
	syscall
	li      $v0,5           #  cin >> redData[1] ;
	syscall
	sw      $v0,4($s3)
	la      $a0,prmpt3      #  cout << prmpt3 ;
	li      $v0,4
	syscall
	la      $s3,greenData   #  cin >> greenData[0] ;
	li      $v0,5
	syscall
	sw      $v0,($s3)
	la      $a0,prmpt4      #  cout << prmpt4 ;
	li      $v0,4
	syscall
	li      $v0,5           #  cin >> greenData[1] ;
	syscall
	sw      $v0,4($s3)

loop:	                        #  do {
	la      $a0,prmpt5      #    cout << "cycle " << cycle << endl ;
	li      $v0,4
	syscall
	move    $a0,$s1
	li      $v0,1
	syscall
	la      $a0,endl
	li      $v0,4
	syscall
	la      $a0,prmpt6      #    cout << "red particle (x,y,xVel,yVel): "
	li      $v0,4
	syscall
	la      $s3, redData
	lw      $a0,($s3)       #       << redData[0]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,4($s3)      #       << redData[1]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,8($s3)      #       << redData[2]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,12($s3)     #       << redData[3]
	li      $v0,1
	syscall
	la      $a0,endl        #       << endl ;
	li      $v0,4
	syscall
	la      $a0,prmpt7      #    cout << "green particle (x,y,xVel,yVel): "
	li      $v0,4
	syscall
	la      $s3, greenData
	lw      $a0,($s3)       #       << greenData[0]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,4($s3)      #       << greenData[1]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,8($s3)      #       << greenData[2]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,12($s3)     #       << greenData[3]
	li      $v0,1
	syscall
	la      $a0,endl        #       << endl ;
	li      $v0,4
	syscall
	la      $a0,endl        #       << endl ;
	li      $v0,4
	syscall
  
	la      $a0,redData     #    updatePoint(redData) ;
	jal     updatePoint
	la      $a0,greenData   #    updatePoint(greenData) ;
	jal     updatePoint
	
	la      $s3,redData     #    dist = findDistance(redData[0],
	lw      $a0,($s3)       #       redData[1], greenData[0],
	lw      $a1,4($s3)      #       greenData[1]) ;
	la      $s4,greenData
	lw      $a2,($s4)
	lw      $a3,4($s4)
	jal     findDistance
	move    $s2,$v0
       
	add     $s1,$s1,1       #    cycle++ ;
	ble     $s2,2,exit      #  } while ((dist > 2) && (cycle < 10)) ;
	blt     $s1,10,loop
exit:
	bgt     $s2,2,end       #  if (dist <= 2) {
	la      $a0,prmpt8      #    cout << prmpt8 ;
	li      $v0,4
	syscall
	la      $a0,prmpt6      #    cout << "red particle (x,y,xVel,yVel): "
	li      $v0,4
	syscall
	la      $s3, redData
	lw      $a0,($s3)       #       << redData[0]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,4($s3)      #       << redData[1]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,8($s3)      #       << redData[2]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,12($s3)     #       << redData[3]
	li      $v0,1
	syscall
	la      $a0,endl        #       << endl ;
	li      $v0,4
	syscall
	la      $a0,prmpt7      #    cout << "green particle (x,y,xVel,yVel): "
	li      $v0,4
	syscall
	la      $s3, greenData
	lw      $a0,($s3)       #       << greenData[0]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,4($s3)      #       << greenData[1]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,8($s3)      #       << greenData[2]
	li      $v0,1
	syscall
	la      $a0,space       #       << " "
	li      $v0,4
	syscall
	lw      $a0,12($s3)     #       << greenData[3]
	li      $v0,1
	syscall
	la      $a0,endl        #       << endl ;
	li      $v0,4
	syscall
	la      $a0,endl        #       << endl ;
	li      $v0,4
	syscall
end:	li      $v0,10          #  }
	syscall                 #}
	
updatePoint:
#save in stack return address
        addi $sp, $sp, 8
        sw   $ra, 4($sp)
        sw   $s1, 0($sp)
        

        move $t0, $a0
        
        lw $a0, 0($t0)        # arg[0]
        lw $a1, 4($t0)        # arg[1]
        li $a2, 0
        li $a3, -1            
        jal findDistance      # distance in $v0

        lw $t2, 8($t0)        # arg[2]
                
        bge $v0, 1, skip1     # if ((distance < 1) 
        bge $t2, 0, skip1     # && (arg[2] < 0))
        mul $t2, $t2, -1      
        sw $t2, 8($t0)        # then arg[2] = -arg[2]
skip1: 

        lw $a0, 0($t0)        # arg[0]
        lw $a1, 4($t0)        # arg[1]
        li $a2, 10
        li $a3, -1            
        jal findDistance      # distance in $v0
        

        lw $t2, 8($t0)        # arg[2]
                
        bge $v0, 1, skip2     # if ((distance < 1) 
        ble $t2, 0, skip2     # && (arg[2] > 0))
        mul $t2, $t2, -1      
        sw $t2, 8($t0)        # then arg[2] = -arg[2]
skip2:

        lw $a0, 0($t0)        # arg[0]
        lw $a1, 4($t0)        # arg[1]
        li $a2, -1
        li $a3, 0            
        jal findDistance      # distance in $v0

        lw $t3, 12($t0)        # arg[3]
                
        bge $v0, 1, skip3     # if ((distance < 1) 
        bge $t3, 0, skip3     # && (arg[3] < 0))
        mul $t3, $t3, -1      
        sw $t3, 12($t0)        # then arg[3] = -arg[3]
skip3:
        lw $a0, 0($t0)        # arg[0]
        lw $a1, 4($t0)        # arg[1]
        li $a2, -1
        li $a3, 10            
        jal findDistance      # distance in $v0

        lw $t3, 12($t0)        # arg[3]
                
        bge $v0, 1, skip4     # if ((distance < 1) 
        ble $t3, 0, skip4     # && (arg[3] > 0))
        mul $t3, $t3, -1      
        sw $t3, 12($t0)        # then arg[3] = -arg[3]
skip4:

        lw $t1, 0($t0)        # arg[0]        
        lw $t2, 4($t0)        # arg[1]
        lw $t3, 8($t0)        # arg[2]                
        lw $t4, 12($t0)        # arg[3]
        
        add $t1, $t1, $t3
        add $t2, $t2, $t4
        
        sw $t1, 0($t0)
        sw $t2, 4($t0)
        
#load from stack the return address
        lw $s1, 0($sp)
        lw $ra, 4($sp)
#move pointer stack one step back        
        addi $sp, $sp, -8
#return from subroutine
        jr $ra
        
findDistance:
#save in stack return address
        addi $sp, $sp, 8
        sw   $ra, 4($sp)
        sw   $s1, 0($sp)

        sub $s0, $a0, $a2        # distX = arg0 - arg2;
        bge $s0, 0, skipDistXNeg # if (distX < 0) 
        mul $s0, $s0, -1         #   distX = - distX; 
skipDistXNeg:                
 
        sub $s1, $a1, $a3        # distY = arg[1] - arg[3]
        bge $s1, 0, skipDistYNeg # if (distX < 0) 
        mul $s1, $s1, -1         #   distY = - distY; 
skipDistYNeg:                
        
         slt $t5, $a0, $0         #  if ((arg0 < 0)  || (arg2 < 0))
         slt $t6, $a2, $0
         or  $t7, $t5, $t6
         beq $t7, 1, returnDistY #            return distY;
                                
         slt $t5, $a1, $0         #  else if ((arg1 < 0)  || (arg3 < 0))
         slt $t6, $a3, $0
         or  $t7, $t5, $t6
         beq $t7, 1, returnDistX #            return distX;
                                 
returnSumDistXY:                 #  else
        add $v0, $s0, $s1        #    return distX + distY;
        j return

returnDistY:
        move $v0, $s1
        j return

returnDistX:
        move $v0, $s0
        j return 
        
return:       
        
#load from stack the return address
        lw $s1, 0($sp)
        lw $ra, 4($sp)
#move pointer stack one step back        
        addi $sp, $sp, -8
#return from subroutine
        jr $ra
