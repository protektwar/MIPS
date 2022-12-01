.data

size:      .word 0
n:         .word 0
the_list:  .word 0
count:     .word 0

enterArrayLengthMsg: .asciiz "Enter array length: "
enterNMsg:           .asciiz "Enter n: "
enterTheValueMsg:    .asciiz "Enter the value: "
numberOfMultiplesMsg:.asciiz "\nThe number of multiples (excluding itself): "

.text

  jal readArrayLength
  sw $v0, size
  
  jal readN
  sw $v0, n

  lw $a0, size  
  jal allocatedMemory4Array
  sw $v0, the_list           #write returned address for the allocated memory in heap
  
  lw $a0, the_list           #send list address as 1st param
  lw $a1, size               #send list size as 2nd param
  lw $a2, n
  jal readValues
  sw $v0, count
  
  lw $a0, count
  jal printMultipleCounter
  
  j exit
  

readArrayLength:
  la $a0, enterArrayLengthMsg
  li $v0, 4                 # print string 
  syscall
  
  li $v0, 5                 # read int
  syscall
                            #v0 will contain the read int
  jr $ra

readN:
  la $a0, enterNMsg
  li $v0, 4                 # print string 
  syscall
  
  li $v0, 5                 # read int
  syscall
                            #v0 will contain the read int
  jr $ra
  
readValues:

  move $t0, $a0
  move $t1, $a1
  move $t4, $a2
  
  li $t2, 0                #init for index
  
  li $t5, 0                #count
  
forLoop:

  mul $s0, $t2, 4          # mul index with 4 as each value will be located in 32bits memory 
  add  $s0, $s0, $t0       # add base address to calculated position
  
  li $v0, 4
  la $a0, enterTheValueMsg
  syscall
  li $v0, 5                #read int
  syscall
  
  sw $v0, 0($s0)           #save read int at calculated address

if:                        # the_list[n] % n == 0
  rem $t3, $v0, $t4
  bnez $t3, skip

  beq $v0, $t4, skip       # the_list[n] != n
  
  addi $t5, $t5, 1         # then inc counter

skip:  
  addi $t2, $t2, 1    #j++
  blt  $t2, $t1, forLoop    #we keep going until the end of the loop
  
  move $v0, $t5
  jr $ra
  
allocatedMemory4Array:
  li $v0, 9                 #alocate heap memory
                            #$a0 comes as parameter
  syscall
                            #$v0 will contain the address of allocated memeory
  jr $ra

printMultipleCounter:

  move $t0, $a0            #move 1st param to $t0
  
  li $v0, 4
  la $a0, numberOfMultiplesMsg 
  syscall
  
  li $v0, 1 
  move $a0, $t0
  syscall
      
exit:

  li $v0, 10
  syscall