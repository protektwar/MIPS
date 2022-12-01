    .data
x:  .word    1        #int x[] = {1, 29, 13, 6, 5, 3, 1, 7}
    .word    29
    .word    13
    .word    6
    .word    5
    .word    3
    .word    1
    .word    7
    
descend:.word    0:8        #int descend[8] = {0};
endl:    .asciiz    "\n"

# j $s0
# i $s1
# &x[0] $s2
# &descend[0] $s3

    
    .text
main:    
    li     $s0, 0        #  int j = 0;
    la     $s2, x
    la     $s3, descend

    li     $s1, 0        #  for (int i=0; i<7; i++) {
for:    
    mul    $t0, $s1, 4    #    if ((x[i] / x[i+1]) >= 2) {
    add    $t0, $t0, $s2
    lw     $t1, ($t0)    # $t1 = x[i]
    
    lw     $t2, 4($t0)    # $t2 = x[i+1]
    
    div    $t3, $t1, $t2    # $t3 = x[i]/x[i+1]
    
    ble    $t3, 1, skip    # since 1 < 2, we use 1, the reason for ble is because if it doesnt meet condition we want it to do something else, in this case skip the index
    
    mul    $t4, $s0, 4    #needed for j index
    add    $t4, $t4, $s3    
    sw     $s1, ($t4)    #      descend[j] = i;
    addi   $s0, $s0, 1    #      j++;
skip: 
    addi   $s1, $s1, 1    #i++
    blt    $s1, 7, for    #we keep going until the end of the loop
                          #    }

    
    li    $s1, 0      #  for (int i=0; i<j; i++) {
for1:    
   mul    $t0, $s1, 4
    add   $t0, $t0, $s3
    lw    $a0, ($t0)
    li    $v0, 1
    syscall            #    cout << descend[i] << endl;
    la    $a0, endl
    li    $v0, 4
    syscall            #  }

    addi    $s1, $s1, 1
    blt    $s1, $s0, for1

    li    $v0, 10
    syscall