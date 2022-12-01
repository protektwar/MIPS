# Description: Calculates the sum, mean, min, max and variance of a series of numbers.#

.data
msg1:           .asciiz "Enter 5 integers:\n"
msg2:           .asciiz "Enter another Number: "
msg3:           .asciiz "\nThe Sum of the numbers is: "
msg4:           .asciiz "\nThe Smallest number is: "
msg5:           .asciiz "\nThe Largest number is: "
msg6:           .asciiz "\nThe Mean of the numbers is: "
msg7:           .asciiz "\nThe variance of the numbers is: "
msg8:           .asciiz "\nFloating Point List:\n"
msgNewLine:     .asciiz "\n"

array:          .word 4
arrayLength:    .word 5
arrayIdxCnt:    .word 0
sumOfElements:  .word 4
minOfElements:  .word 4
maxOfElements:  .word 4
avgOfElements:  .word 4
varianceOfElem: .word 4

.text

.globl main
main:

   li $v0, 9                     # allocate heap for array
   lw $a0, arrayLength           # load array length
   mul $a0, $a0, 4               # number of bytes to allocate $a0 = $a0 * 4; in our case $a0 = 5 * 4
   syscall
   
   sw $v0, array                 # store the address returned by the above function in array
                                 # array will hold address of the number of bytes alocated in heap memory

   lw $a0, array                 #load as parameter for readArray $a0 with address stored in array
   jal readArray

   lw $a0, array                 #load as parameter for readArray $a0 with address stored in array
   jal listArray

   lw $a0, array                 #load as parameter for readArray $a0 with address stored in array
   jal sum 

   lw $a0, array                 #load as parameter for readArray $a0 with address stored in array
   jal min

   lw $a0, array                 #load as parameter for readArray $a0 with address stored in array
   jal max

   jal meanValue

   lw $a0, array                 #load as parameter for readArray $a0 with address stored in array
   jal variance
   
   j exit

readArray:
  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  lw $t3, arrayIdxCnt
  
  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg1                   # load $a0 with address of msg1
  syscall                        # call the system service
 
   
forloop:
#{
  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg2                   # load $a0 with address of msg2
  syscall                        # call the system service
  
  li $v0, 5                      # read interger
  syscall                        # call the system service
  
  mtc1 $v0, $f12                 # move value of $v0 to $f12 
  cvt.s.w $f12, $f12             # convert to single precision float
    
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  s.s      $f12, 0($s0)          # load to $f0 the float value stored at $s0 location calculated above
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloop
#}
  jr $ra
  
listArray: #param array address

  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  lw $t3, arrayIdxCnt
  
  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg8                   # load $a0 with address of msg8
  syscall                        # call the system service
 
   
forloopList:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  l.s      $f12, 0($s0)           # load to $f0 the float value stored at $s0 location calculated above
  
  li $v0, 2                      # print float
  syscall                        # call the system service
  
  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msgNewLine             # load $a0 with address of msgNewLine
  syscall                        # call the system service
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopList
#}
  jr $ra

sum: #param array address
  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  lw $t3, arrayIdxCnt
  
  mtc1 $zero, $f12                 # move value of $v0 to $f12 
  cvt.s.w $f12, $f12             # convert to single precision float
   
forloopSum:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  l.s      $f0, 0($s0)           # load to $f0 the float value stored at $s0 location calculated above
  
  add.s    $f12, $f12, $f0
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopSum
#}

  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg3                   # load $a0 with address of msg3
  syscall                        # call the system service

  li $v0, 2                      # print float
  syscall                        # call the system service
  
  s.s $f12, sumOfElements

   # return sum
   jr $ra 
   
max: #param array address
  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  lw $t3, arrayIdxCnt
 
  l.s $f12, 0($t1)               # load in $f12 first element of Array
  addi $t3, $t3, 1               # start array position from 1 as 0 is loaded in $f12
   
forloopMax:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  l.s      $f0, 0($s0)           # load to $f0 the float value stored at $s0 location calculated above
  c.le.s   $f0, $f12
  bc1t     already_max
#set_max:
  movf.s   $f12, $f0
already_max:
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopMax#}

  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg5                   # load $a0 with address of msg4
  syscall                        # call the system service

  li $v0, 2                      # print float
  syscall                        # call the system service

  #return max from array
  jr $ra
  
min: #param array address
  move $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw $t2, arrayLength
  lw $t3, arrayIdxCnt
 
  l.s $f12, 0($t1)               # load in $f12 first element of Array
  addi $t3, $t3, 1               # start array position from 1 as 0 is loaded in $f12
   
forloopMin:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  l.s      $f0, 0($s0)           # load to $f0 the float value stored at $s0 location calculated above
  c.lt.s   $f12, $f0
  bc1t     1, already_min
#set_max:
  movf.s   $f12, $f0
already_min:
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopMin
  #}

  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg4                   # load $a0 with address of msg4
  syscall                        # call the system service

  li $v0, 2                      # print float
  syscall                        # call the system service

  #return min from array
  jr $ra

meanValue: #param array address
  l.s $f0, sumOfElements
  lw $t1, arrayLength

  mtc1 $t1, $f1               # move value of $v0 to $f12 
  cvt.s.w $f1, $f1             # convert to single precision float
   
  div.s $f12, $f0, $f1

  s.s $f12, avgOfElements

  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg6                   # load $a0 with address of msg4
  syscall                        # call the system service
   
  li $v0, 2                      # print float
  syscall                        # call the system service
    
  #return meanValue
  jr $ra

variance:  #param array address
  move     $t1, $a0                  # $t1 will hold array's address which was passed as parameter in $a0
  lw       $t2, arrayLength
  lw       $t3, arrayIdxCnt
  
  l.s      $f1, avgOfElements  
  
  li       $t4, -1
  mtc1     $t4, $f2
  cvt.s.w  $f2, $f2
  
  mul.s    $f1, $f1, $f2           # negativate the MeanValue
  
  mtc1     $zero, $f12            # move value of $0 to $f12 
  cvt.s.w  $f12, $f12             # convert to single precision float
   
forloopVariance:
#{
  move     $s0, $t3              # use $s0 as array offset = 0
  sll      $s0, $s0, 2           # $s0 *= 4 (shift left 2 bits) for byte offset
  add      $s0, $s0, $t1
  l.s      $f0, 0($s0)           # load to $f0 the float value stored at $s0 location calculated above
   
  add.s    $f0, $f0, $f1         # xi - Avg
  mul.s    $f0, $f0, $f0         # (xi - Avg)^^2
 
  add.s    $f12, $f12, $f0
  
  addi     $t3, $t3, 1
  bne      $t3, $t2, forloopVariance
#}

  addi     $t2, $t2, -1

  mtc1     $t2, $f1
  cvt.s.w  $f1, $f1
  
  div.s $f12, $f12, $f1

  li $v0, 4                      # load $v0 with 4 for printing the string loaded in $a0
  la $a0, msg7                   # load $a0 with address of msg3
  syscall                        # call the system service

  li $v0, 2                      # print float
  syscall                        # call the system service
  
  s.s $f12, sumOfElements

   # return variance
   jr $ra

exit:
  li $v0, 10
  syscall   
  
