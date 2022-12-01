# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
main:
    li $t0, 0   #int i = 0;
    li $s4, 1   
    
loop:
    bge $t0, 1000, end1 # while (i < 1000)  {
    la  $s0, prime      # load prime array address
    mul $t1, $t0, 4     # calculate element position
    add $t2, $s0, $t1   # add it to the base address of prime array
    sw  $s4, ($t2)        # prime[i] = 1
    add $t0, $t0, 1     # i++
    b loop              # }

end1:
    la $s0, prime
    li $t0, 2           # int i = 2;
                        # $t3 = prime[i]
loop2:
    mul $t1, $t0, 4     # calculate element position
    add $t2, $s0, $t1   # add it to the base address of prime array
    lw $t3, 0($t2)

    bge $t0, 1000, end2  # while (i < 1000) {
    bnez $t3, if         # if (prime[i] != 0) goto if
    b end3
if:     
        move $a0, $t0      #printf("%d\n", i); 
        li $v0, 1
        syscall
        li   $a0, '\n'      # printf("%c", '\n');
        li   $v0, 11
        syscall
                            # $s3 = j 
        mul $s3, $t0, 2     # int j = i * 2;
        loop3:             
            bge $s3, 1000, end3     # while (j < 1000) {
            mul $t3, $s3, 4         # calculate element position
            add $t4, $t3, $s0       # add it to the base address of prime[j],  $t4 = prime[j]
            li  $s4, 0              
            sw  $s4, 0($t4)            # prime[j] = 0;
            add $s3, $s3, $t0       # j = j + i;
            b loop3
end3:                               # }            
    add $t0, $t0, 1
    b loop2



end2:                               # }
    li   $v0, 0          # return 0
#   jr   $ra


.data
prime:
    .space 1000