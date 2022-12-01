.data
#f < h
#coursework:  .word 40, 10, 20, 30, 45, 50, 25,  5, 35, 25
#exam:        .word 35, 20, 50, 45, 50, 30, 10, 40, 15, 25
#results           75, 30, 70, 75, 95, 80, 35, 45 ,50, 50
#                  4B, 1E, 46, 4B, 5F, 50, 23, 2D, 32, 32

#f > h
coursework:  .word 10, 10, 25, 30, 15, 50, 25,  5, 35, 25
exam:        .word 35, 20, 15, 45, 10, 30, 10, 40, 15, 25
#results           45, 30, 40, 75, 25, 80, 35, 45 ,50, 50
#                  2D, 1E, 28, 4B, 19, 50, 23, 2D, 32, 32

results:     .word 0 : 10
y:          .word 10
a:          .word 0
b:          .word 0
c:          .word 0
f:          .word 0
h:          .word 5
d:          .word 0

.text

main: 

	li $t1, 0                     #init $t1 with i for forloop condition, i = 0
	lw $t2, y
	lw $t3, f
	la $s5, results               #load address of results array
	la $s6, coursework            #load address of coursework array
	la $s7, exam                  #load address of exam array
	
#for (i=0; i<y;i++){	
forloop:
	bge      $t1, $t2, exit_forloop

#results[i] = coursework[i] + examp[i];
	move     $s0, $t1             # use $s0 as array offset 
	sll      $s0, $s0, 2          # $s0 *= 4 (shift left 2 bits) for byte offset
	
	add      $t0, $s0, $s6        # calculate element address of coursework[i]
	add      $t7, $s0, $s7        # calculate element address of exam[i]
	lw       $s1, 0($t0)          # load the value from coursework[i] to $s1
	lw       $s2, 0($t7)          # load the value from exam[i] to $s2   
	add      $s3, $s1, $s2        # add and store result from coursework[i]+exam[i] 
	add      $s0, $s0, $s5        # calculate element address of reuslts[i]
	sw       $s3, 0($s0)    # store the value from $s3 in resutls[i]
#if (results[i] < 50)	{
	blt      $s3, 50, inc_f  # if results[i]>=50 jump to dont_inc_f else f = f + 1 aka (if results[i]< 50 f = f + 1)
	b dont_inc_f
inc_f:	
#f=f+1;	
	add      $t3, $t3, 1          # increment f
#}	
dont_inc_f:
	addi     $t1, $t1, 1          #i++
	b forloop
#}
exit_forloop:
        lw       $t3, f
	lw       $t4, h

# if f>h {
	bgt      $t3, $t4, if_f_gt_h
	b ifBranch    
if_f_gt_h: 	
#d = 100 - max(results[]);
        la       $a0, results           # load address of results as 1st parameter for max from results
	jal      func_max_from_results
	add      $t5, $zero, 100
        sub      $t6, $t5, $v0          # d = 100 - max(results[]) 

#for (i=0; i<y; i++){
CURVE_forloop:
	li $t1, 0                     #init $t1 with 0 for forloop condition
CURVE_loop:
	bgt      $t1, $t2, exit_CURVE_loop    # if $t1 <> $t2 jump forloop:
        move     $s0, $t1             # user $s0 as array offset 
	sll      $s0, $s0, 2          # $s0 *= 4 (shift left 2 bits) for byte offset
	la       $a0, results         # param1 resutls array
	move     $a1, $t1             # param2 i
	move     $a2, $t6             # param3 d
#	CURVE(results, i, d);	
	jal 	 func_CURVE
	addi     $t1, $t1, 1
	b CURVE_loop
#}
exit_CURVE_loop:

ifBranch:		
	li       $t1, 0                     #init $t1 with i for forloop condition, i = 0
#f = 0;
	lw       $t2, a
	lw       $t3, b
	lw       $t4, c
	lw       $t1, f
	lw       $t6, y

#for (i=0; i<y; i++){
ifBranch_loop:	
	bgt      $t1, $t6, exit_ifBranch_loop    # if $t1 <> $t2 jump ifBranch_loop:
	move     $s0, $t1             # use $s0 as array offset 
	sll      $s0, $s0, 2          # $s0 *= 4 (shift left 2 bits) for byte offset
	lw       $s1, results($s0) # load the value from coursework array element     
  
        bge       $s1, 70, inc_a           #	if (results[i] >= 70) 
        b next_1           
inc_a:         
        addi      $t2, $t2, 1              #        a = a +1;
        b next_4
        
next_1:
        bge      $s1, 60, inc_b	   #	if (results[i] >= 60)
        b next_2
inc_b:
        addi     $t3, $t3, 1               #       b = b +1;        
        b next_4        
        
next_2:        
        blt      $s1, 50, inc_c  	   #	if (results[i] >= 50)
        b next_3
inc_c:        
        add      $t4, $t4, 1               #         c = c +1;
        b next_4        
        
next_3:
        blt      $s1, 50, incc_f           #	if (results[i] < 50) 
        b next_4
incc_f:        
        add      $t5, $t5, 1               #       f = f +1;
        
next_4:
	addi     $t1, $t1, 1
	b ifBranch_loop                    # branch ifBranch_loop:
#}	

exit_ifBranch_loop:

end_of_program: 
        li       $v0, 10        # system service 10 is exit
        syscall                 # we are outta here.


# function that will calculate the max from results elements
func_max_from_results:
	li  $t1, 0                    #init $t1 with i for forloop condition, i = 0
	add $t5, $zero, $zero                 #max var init with 0
max_forloop:
	move     $s0, $t1             # user $s0 as array offset 
	sll      $s0, $s0, 2          # $s0 *= 4 (shift left 2 bits) for byte offset
	lw       $s3, results($s0)    # store above result in resutls[i]
	ble      $s3, $t5, already_max
#get_max:
        move     $t5, $s3
already_max:        	
	addi     $t1, $t1, 1
	bne      $t1, $t2, max_forloop    # if $t1 <> $t2 jump forloop:
	move     $v0, $t5           # move value stored in $t5 to $v0
        jr       $ra                # return from subroutine max_from_resutls
        
func_CURVE:
#void CURVE(int p[], int z, int k)
#{
#	p[z] = p[z] + k;
#}
	add      $s5, $zero, $a0      # starting address of array of resutls
	move     $s6, $a1             # calculate offset from param2 i
	sll      $s6, $s6, 2          # $s6 *= 4 (shift left 2 bits) for byte offset
	add      $s5, $s5, $s6
        lw       $s7, 0($s5)
        add      $s7, $s7, $a2
        sw       $s7, 0($s5)
        jr   $ra                # return from subroutine CURVE
