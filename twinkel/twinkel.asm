.data
   pitchC: .byte 60
    pitchD: .byte 62
    pitchE: .byte 64
    pitchF: .byte 65
    pitchG: .byte 67
    pitchA: .byte 69
    pitchB: .byte 71
    partition: .word 60, 100, 127, 1, 600, 
                     60, 100, 127, 1, 600, 
                     67, 100, 127, 1, 1000, 
                     67, 100, 127, 1, 600, 
                     69, 100, 127, 1, 600, 
                     69, 100, 127, 1, 1000,
                     67, 100, 127, 1, 600, 

                     65, 100, 127, 1, 200, 
                     65, 100, 127, 1, 200, 
                     64, 100, 127, 1, 200, 
                     64, 100, 127, 1, 200, 
                     62, 100, 127, 1, 200, 
                     62, 100, 127, 1, 200, 
                     60, 100, 127, 1, 200, 

                     67, 100, 127, 7, 200, 
                     67, 100, 127, 14, 200, 
                     65, 100, 127, 14, 200, 
                     65, 100, 127, 14, 200, 
                     64, 100, 127, 14, 200, 
                     64, 100, 127, 14, 200, 
                     62, 100, 127, 14, 200, 

                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     
                     60, 100, 127, 14, 200, 
                     60, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     67, 100, 127, 14, 200, 
                     69, 100, 127, 14, 200, 
                     69, 100, 127, 14, 100,
                     67, 100, 127, 14, 200, 

                     65, 100, 127, 14, 200, 
                     65, 100, 127, 14, 200, 
                     64, 100, 127, 14, 200, 
                     64, 100, 127, 14, 200, 
                     62, 100, 127, 14, 200, 
                     62, 100, 127, 14, 200, 
                     60, 100, 127, 14, 200

        partition_length: .word 210

.text
main:
    
    addi $t0, $zero, 0               #index partition $t0 set to 0
    la $t1, partition                #load partition address to $t1
    lw $t2, partition_length         #load partition length to $t2

while:
        bge $t0, $t2, exit           #Exit condition
        li $v0, 31
        lw $a0, 0($t1)               #pitch
        lw $a1, 4($t1)               #duration
        lw $a3, 8($t1)               #volume
        lw $a2, 12($t1)              #instrument
        syscall
                
        li $v0, 32
        lw $a0, 16($t1)              #delay between notes
        syscall

        addi $t0, $t0, 5             #increment partition with 5, next note
        addi $t1, $t1, 20             #increment partition with 5, next note

       j while 
       
exit:
        li $v0, 10                   #exit syscall
        syscall
