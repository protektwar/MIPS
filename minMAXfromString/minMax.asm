#.globl display

.data
#    input: .ascii "11 22 33 44 55 65 74 83 93 18\n"
     msg:   .ascii "Enter your input: "
     stringInput: .space 124
     intArray:    .word 0
     arrayLength: .word 10
     minNumber:         .word 0
     maxNumber:         .word 0
    
.text    
main:
         
    li $v0, 4
    la $a0, msg
    syscall 
    
    la $a0, stringInput
    li $a1, 124
    li $v0, 8
    syscall
   
    la $a0, stringInput
    jal string_to_int
    la $t0, intArray
    sw $v0, 0($t0)
    
    lw $a0, intArray   
    jal min
    sw $v0, minNumber

    lw $a0, intArray   
    jal max
    sw $v0, maxNumber
    
    lw $a0, minNumber
    lw $a1, maxNumber
    jal display    
    j exit
    
string_to_int:
    move $t0, $a0
    li $t3, ' '    #space delimiter
    li $t4, '\n'   #and of string
    li $t8, '0'
    
    li $v0, 9               #allocate memory in heap 
    li $a0, 40              # 10 * 4 bytes
    syscall 
     
    move $t5, $v0           # $v0 will have the allocated heap address

    li $t1, 0      #init index parce string
    li $t2, 0      #init index array 
    li $s0, 10
    li $s3, 0
    
forStringLoop:
    add $t7, $t1, $t0
    lb $t6, 0($t7)
    beq $t6, $t4, exit_string_to_int
    beq $t6, $t3, skip_conversion
   
    sub $s1, $t6, $t8               # convert to int = ord(char) - ord(0) 
    mul $s1, $s1, $s0               # first is tens second is units
    div $s0, $s0, 10                # prepare tens or units
    add $s3, $s3, $s1               # build the number
    
    j next    
skip_conversion:       
    add $s5, $t5, $t2
    sw $s3, 0($s5)
    
    addi $t2, $t2, 4
  
    li $s0, 10
    li $s3, 0
    
next: 
    addi $t1, $t1, 1
    j forStringLoop
    
exit_string_to_int:    

    add $s5, $t5, $t2
    sw $s3, 0($s5)
    
    move $v0, $t5       # return heap address of array

    jr $ra
            
max: #param array address
  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  li $t3, 0
 
  lw $t4, 0($t1)               # load in $t4 first element of Array
  addi $t3, $t3, 1               # start array position from 1 as 0 is loaded in $t4
   
forloopMax:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  lw       $t5, 0($s0)           # load to $t5 the float value stored at $s0 location calculated above
  slt      $t8, $t5, $t4
  beq      $t8, 1, already_max
#set_max:
  move     $t4, $t5
already_max:
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopMax#}

  move $v0, $t4

  #return max from array
  jr $ra
  
min: #param array address
  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  li $t3, 0
 
  lw $t4, 0($t1)               # load in $t4 first element of Array
  addi $t3, $t3, 1               # start array position from 1 as 0 is loaded in $t4
   
forloopMin:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  lw       $t5, 0($s0)           # load to $t5 the float value stored at $s0 location calculated above
  slt      $t8, $t4, $t5
  beq      $t8, 1, already_min
#set_min:
  move     $t4, $t5
already_min:
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopMin
  #}


  move $v0, $t4
  #return min from array
  jr $ra
  
exit:
    addi $v0, $0, 10
    syscall                


display:
        
    li $v0, 1
    syscall
    
    li $a0, ' '
    li $v0, 11
    syscall
    
    move $a0, $a1
    li $v0, 1
    syscall
    jr $ra
