# DONOTMODIFYTHISLINE
.data
frameBuffer: .space 0x80000 # 512 wide X 256 high pixels
w: .word 
h: .word 
d: .word 
chr: .word 0x00FF0000
chg: .word 0x0000FF00
chb: .word 0x000000FF
cdr: .word 
cdg: .word 
cdb: .word 0xD2691E
# DONOTMODIFYTHISLINE
# Your variables go BELOW here only
bufferSize:  .word 0x20000	#Size of buffer
displayHeight: .word 2048	#Height of display
.text
main:
        lw     $a0, bufferSize     #bufferSize 
        li     $a1, 0x00FFFF00     #color
        jal    clear_screen	#call clear_screen
           
        #draw blue filled rectangle
        li     $a0, 192        #x0 length start point
        li     $a1, 127        #y0 height start point
        li     $a2, 320        #x1 length end point
        li     $a3, 255        #y1 height end point
        lw     $t4, chb       	#t4<-blue
        jal    draw_filled_rectangle	#call draw_filled_rectangle

        #draw cdb filled rectangle
        li     $a0, 248        #x0
        li     $a1, 200        #y0
        li     $a2, 264        #x1
        li     $a3, 255        #y1
        lw     $t4, cdb        #t4<-brown
        jal    draw_filled_rectangle	#call draw_filled_rectangle
        
        li     $t0, 256        #t0<-Vertice1 x
        li     $t1, 62         #t1-<Vertice1 y
        li     $t2, 191        #t2<-Vertice2 x
        li     $t3, 127        #t3<-Vertice2 y
        li     $t4, 325        #t4<-Vertice3 x
        li     $t5, 127        #t5<-Vertice3 y
        lw     $t7, cdb     	#t7<-brown
        jal    draw_filled_triangle

        j   end_program		#jump to end_program
        
#clear the screen with yellow color                        
clear_screen:
	add   $t1, $zero, $a0	#t1<-bufferSize
	add   $t2, $zero, $a1	#t2<-yellow

clear_screen_loop:
        sw     $t2, frameBuffer($t0)	#t2<-load address of frameBuffer
        beq    $t1, $zero, clear_screen_loop_end #exit if number of pixels = 0
        addi   $t0,$t0, 4        #t0<-advance to next pixel position in display
        addi   $t1,$t1, -1       #t1<-decrement number of pixels  
        j      clear_screen_loop #repeat while number of pixels not zero
       
clear_screen_loop_end:        
#end clear_screen_loop

clear_screen_exit:
	jr $ra		#return to caller

draw_filled_triangle: 
        add $sp, $sp -4		 #push
        sw $ra, 0($sp)		 #...ra
        add  $s7, $zero, $t3     #s7<- Vertice2 y for loop exit condition
        add  $t6, $zero, $t1   	 #t6<- Vertice1 y
        add  $t8, $zero, $t0     #t8<- Vertice1 x 
        add  $t9, $zero, $t0     #t9<- Vertice1 x   

scan_line_y_loop:
	beq     $t6, $s7, scan_line_y_loop_exit	#if Vertice2 y and Verticie1 y meet, exit
        add     $a0, $zero, $t8		#a0<-Vertice1 x
        add     $a1, $zero, $t6		#a0<-Vertice1 x
        add     $a2, $zero, $t9		#a2<-Verticie1 x
        add     $a3, $zero, $t6		#a3<-Verticie1 y
        				#color is in $t7
        jal draw_line			#call draw_line
        
        addi    $t6, $t6, 1		#t6<-V1 x+1
        addi    $t8, $t8 ,-1 		#t8<-V1 x-1 (255,254,253,...)
        addi    $t9, $t9 ,1  		#t9<-V1 x+1 (257,258,259...)
        j scan_line_y_loop		#jump to scan_line_y_loop

scan_line_y_loop_exit:
#exit from scan_line_y_loop

draw_filled_triangle_exit:
        lw $ra, 0($sp)			#Pop $ra
        addi $sp, $sp, 4		#reclaim stack space
	jr $ra				#return to caller

draw_line:
        addi $sp, $sp, -16		#push
        sw $ra, 0($sp)			#...ra
        sw $s5, 4($sp)			#...s5
        sw $s6, 8($sp)			#...s6
        sw $s7, 12($sp)       		#...s7
	add  $s5, $zero, $a1 		# s5<-y line
        add  $s6, $zero, $a0 		# s6<-x1 
        add  $s7, $zero, $a2 		# s7<-x2

draw_line_loop:       
        #bgt $s6, $s7, draw_line_loop_exit  
        slt $t4,$s7,$s6		#if(x2<x1) t4=1, else=0
        bne $t4,$zero,draw_line_loop_exit     #if t4 !=0 jump exit loop
        add  $a0,$zero, $s6	#a0<-x1
        add  $a1,$zero, $s5	#a1<-y
        add  $a2,$zero, $t7	#a2<-brown	
        jal  put_pixel		#call put_pixel
        addi $s6, $s6, 1	#s6<-x1+1
        j draw_line_loop 	#loop
 
draw_line_loop_exit:
#exit from draw_line_loop

draw_line_exit:
        lw $s7, 12($sp)		#pop s7
        lw $s6, 8($sp)		#pop s6
        lw $s5, 4($sp)		#pop s5
        lw $ra, 0($sp)		#pop ra
        addi $sp, $sp, 16	#reclaim stack space
	jr $ra			#return to caller

#put pixel at x,y with color                                                 
put_pixel:
        addi $sp, $sp -16	#push
        sw $ra, 0($sp)		#...ra
        sw $t7, 4($sp)		#...t7
        sw $s3, 8($sp)		#...s3
        sw $s0, 12($sp)		#...s0
        #$a0 will have x
        #$a1 will have y
        #$a2 will have the color
        sll  $s3, $a0, 2          #s3<- x * 4 calculate the pixel position in buffer
        sll  $s0, $a1, 11         #s0<- y * 2048 
        add  $s0, $s0, $s3        #s0<-x * 4 + y * 2048
        sw   $a2, frameBuffer($s0) #a2<-write pixel color at calculated buffer memory Address
                                                                                                                                                
put_pixel_exit:
        lw $s0, 12($sp)		#pop s0
        lw $s3, 8($sp)		#pop s3
        lw $t7, 4($sp)		#pop t7
        lw $ra, 0($sp)		#pop ra
        addi $sp, $sp, 16	#reclaim stack space
        jr $ra			#return to caller
                                                                                                                                                                                                                             
#draw a filled rectangle                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
draw_filled_rectangle:
        addi $sp, $sp -4	#push
        sw   $ra, 0($sp)	#...ra
	add  $t0, $zero, $a0    # t0<-x0 length start point
	add  $t1, $zero, $a1    # t1<-y0 height start point
	add  $t2, $zero, $a2    # t2<-x1 length start point
	add  $t3, $zero, $a3    # t3<-y0 height start point
			 	#color will be in $t4	
	sub  $t2, $t2, $t0   #t2<-length of x to be drawn 
	sub  $t3, $t3, $t1   #t3<-length of y to be drawn
	li   $t5, 0          #t5<-index x 
	li   $t6, 0          #t6<-index y

draw_rectangle_y:
        slt  $s5, $t3, $t5   #s5<-if ($t3 < $t5) $s5 = 1 else =0
	bne  $s5, $zero, draw_rectangle_y_end #s5<-if(s5 != 0) exit
	
draw_rectangle_x:
        add  $s1, $t1, $t5        #s1<- y = initial position $a0 + y index advancement
        add  $s2, $t0, $t6        #s2<- x = initial position $a1 + x index advancement
        add  $a0, $zero, $s2	  #a0<- x
        add  $a1, $zero, $s1	  #a1<- y
        add  $a2, $zero, $t4  	  #a2<- color
        jal  put_pixel		  #call put_pixel
	beq  $t6, $t2, draw_rectangle_x_end  #if condition meet exit  (x = x1 - x0)       
        addi  $t6, $t6, 1         # increment x advancement        
        j draw_rectangle_x        # repeat for next x position
        
draw_rectangle_x_end:
        li   $t6,0                #t6<- x advancement with 0, redo the same procedure for the next line 
        addi $t5, $t5, 1          #t5<-increment y advancement
        j draw_rectangle_y        # repeat for next y line

draw_rectangle_y_end:
#exit from draw_rectangle_y

draw_filled_rectangle_exit:
        lw   $ra, 0($sp)	#pop ra
        addi $sp, $sp, 4	#restore memory space
	jr $ra 			#return to caller                        
        
end_program:
        li $v0, 10	#exit code
        syscall		#exit to OS
