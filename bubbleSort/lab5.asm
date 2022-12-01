.data
A:          .space 80   # create integer array with 20 elements ( A[20] )
size_prompt:        .asciiz     "Enter array size [between 1 and 20]: "
array_prompt:       .asciiz     "A["
sorted_array_prompt:        .asciiz     "Sorted A["
close_bracket:      .asciiz     "] = "
search_prompt:      .asciiz "Enter search value: "
not_found:          .asciiz " not in sorted A"
newline:            .asciiz     "\n"  
.text
main:   
    # ----------------------------------------------------------------------------------
    # Do not modify
    #
    # MIPS code that performs the C-code below:
    #
    #   int A[20];
    #   int size = 0;
    #   int v = 0;
    #
    #   printf("Enter array size [between 1 and 20]: " );
    #   scanf( "%d", &size );
    #
    #   for (int i=0; i<size; i++ ) {
    #
    #       printf( "A[%d] = ", i );
    #       scanf( "%d", &A[i]  );
    #
    #   }
    #
    #   printf( "Enter search value: " );
    #   scanf( "%d", &v  );
    #
    # ----------------------------------------------------------------------------------
    la $s0, A           # store address of array A in $s0
  
    add $s1, $0, $0     # create variable "size" ($s1) and set to 0
    add $s2, $0, $0     # create search variable "v" ($s2) and set to 0
    add $t0, $0, $0     # create variable "i" ($t0) and set to 0
    addi $v0, $0, 4         # system call (4) to print string
    la $a0, size_prompt         # put string memory address in register $a0
    syscall                 # print string
  
    addi $v0, $0, 5     # system call (5) to get integer from user and store in register $v0
    syscall         # get user input for variable "size"
    add $s1, $0, $v0        # copy to register $s1, b/c we'll reuse $v0
  
prompt_loop:
    # ----------------------------------------------------------------------------------
    slt $t1, $t0, $s1       # if( i < size ) $t1 = 1 (true), else $t1 = 0 (false)
    beq $t1, $0, end_prompt_loop     
    sll $t2, $t0, 2     # multiply i * 4 (4-byte word offset)
                
    addi $v0, $0, 4         # print "A["
    la $a0, array_prompt            
    syscall  
                        
    addi $v0, $0, 1     # print value of i (in base-10)
    add $a0, $0, $t0            
    syscall 
                    
    addi $v0, $0, 4         # print "] = "
    la $a0, close_bracket       
    syscall                 
    
    addi $v0, $0, 5     # get input from user and store in $v0
    syscall             
    
    add $t3, $s0, $t2       # A[i] = address of A + ( i * 4 )
    sw $v0, 0($t3)      # A[i] = $v0 
    addi $t0, $t0, 1        # i = i + 1
        
    j prompt_loop       # jump to beginning of loop
    # ----------------------------------------------------------------------------------    
end_prompt_loop:
    addi $v0, $0, 4         # print "Enter search value: "
    la $a0, search_prompt           
    syscall 
    
    addi $v0, $0, 5     # system call (5) to get integer from user and store in register $v0
    syscall         # get user input for variable "v"
    add $s2, $0, $v0        # copy to register $s2, b/c we'll reuse $v0
    # ----------------------------------------------------------------------------------
    # TODO: PART 1
    #   Write the MIPS-code that performs the the C-code (bubble sort) shown below.
    #   You may only use the $s, $v, $a, $t registers (and of course the $0 register)
    #   The above code has already created array A and A[0] to A[size-1] have been 
    #   entered by the user. After the bubble sort has been completed, the values in
    #   A are sorted in increasing order, i.e. A[0] holds the smallest value and 
    #   A[size -1] holds the largest value.
    #   
    #   int t = 0;
    #   
    #   for ( int i=0; i<size-1; i++ ) {
    #       for ( int j=0; j<size-1-i; j++ ) {
    #           if ( A[j] > A[j+1] ) {
    #               t = A[j+1];
    #               A[j+1] = A[j];
    #               A[j] = t;
    #           }
    #       }
    #   }
    #           
    # ----------------------------------------------------------------------------------
    
# t := $t0
# i := $t1
# size - 1 == $t2
# Initialize variables (t = 0, i = 0, $t2 = size - 1)
    li $t0, 0
    li $t1, 0
    addi $t2, $s1, -1
for1:
    # Check for loop condition (i < $t2), break if false
    slt $t8, $t1, $t2
    beq $t8, $0, endfor1
    # j := $t3
    # size - 1 - i = $t4
    # Initialize variables for inner loop (j = 0, $t4 = size - 1 - i)
    li $t3, 0
    sub $t4, $s1, $t1
    addi $t4, $t4, -1
for2:
    # Check inner loop conditions (j < $t4), break if false
    slt $t8, $t3, $t4
    beq $t8, $0, endfor2
    # $t5 := A[j]
    # $t6 := A[j + 1]
    # Load A[j] in $t5 and A[j + 1] in $t6
    sll $t5, $t3, 2
    la $t6, A
    add $t5, $t5, $t6
    addi $t6, $t5, 4
    # Keep a copy of &A[j] in $t7
    add $t7, $0, $t5
    lw $t5, 0($t5)
    lw $t6, 0($t6)
    #           if ( A[j] > A[j+1] ) {
    #               t = A[j+1];
    #               A[j+1] = A[j];
    #               A[j] = t;
    #           }
    # Check if A[j] + 1 < A[j], skip if false
    slt $t8, $t6, $t5
    beq $t8, $0, skipif1
    # Swap A[j] and A[j + 1]
    sw $t6, 0($t7)
    addi $t7, $t7, 4
    sw $t5, 0($t7)
skipif1:
    # j++ for the inner loop
    addi $t3, $t3, 1
    j for2
endfor2:
    # i++ for the outer loop
    addi $t1, $t1, 1
    j for1
endfor1:
    # ----------------------------------------------------------------------------------
    # TODO: PART 2
    #   Write the MIPS-code that performs the C-code (binary search) shown below.
    #   You may only use the $s, $v, $a, $t registers (and of course the $0 register)
    #   The array A has already been sorted by your code above int PART 1, where A[0] 
    #   holds the smallest value and A[size -1] holds the largest value, and v holds 
    #   the search value entered by the user
    #   
    #   int left = 0;
    #   int right = size - 1;
    #   int middle = 0;
    #   int element_index = -1;
    #
    #   while ( left <= right ) { 
          #
          #     middle = left + (right - left) / 2; 
    #
            #       if ( A[middle] == v) {
            #               element_index = middle;
            #               break;
            #       }
            #
            #       if ( A[middle] < v ) 
            #               left = middle + 1; 
        #       else
            #               right = middle - 1; 
    #
        #   } 
    #
        #   if ( element_index < 0 ) 
        #       printf( "%d not in sorted A\n", v );
        #   else 
        #       printf( "Sorted A[%d] = %d\n", element_index, v );
    #           
    # ----------------------------------------------------------------------------------
    #   int left = 0;
    #   int right = size - 1;
    #   int middle = 0;
    #   int element_index = -1;
    
    # left($t0)
    # right($t1)
    # middle($t2)
    # element_index($t3)
    # Initialize variables
    li $t0, 0
    addi $t1, $s1, -1
    li $t2, 0
    li $t3, -1
while:
    # Check while conditions, skip if right < left (equivalent to !(left <= right))
    slt $t8, $t1, $t0
    bne $t8, $0, endwhile
    # middle = left + (right - left) / 2; 
    sub $t2, $t1, $t0
    srl $t2, $t2, 1
    add $t2, $t2, $t0
    # $t4 := A[middle]
    la $t4, A
    sll $t5, $t2, 2
    add $t4, $t4, $t5
    lw $t4, 0($t4)
    
    bne $t4, $s2, skipif2   # if ( A[middle] == v) {
    add $t3, $t2, $0    #    element_index = middle;
    j endwhile      #    break;
            # }
skipif2:            
    slt $t8, $t4, $s2   # if ( A[middle] < v ) 
    beq $t8, $0, else   #    left = middle + 1; 
    addi $t0, $t2, 1        #    left = middle + 1; 
    j endif         
else:           # else              
    addi $t1, $t2, -1   #    right = middle - 1; 
endif:
    j while
    
endwhile:   
    slt $t8, $t3, $0    # if ( element_index < 0 ) 
    beq $t8, $0, else2
    add $a0, $s2, $0
    li $v0, 1
    syscall
    la $a0, not_found       # printf( "%d not in sorted A\n", v );
    li $v0, 4
    syscall
    la $a0, newline
    syscall
    j endif2
else2:          # else
    li $v0, 4
    la $a0, sorted_array_prompt         # printf( "Sorted A[%d] = %d\n", element_index, v );
    syscall
    li $v0, 1
    add $a0, $0, $t3
    syscall
    li $v0, 4
    la $a0, close_bracket
    syscall
    li $v0, 1
    add $a0, $0, $s2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
endif2:
    
# ----------------------------------------------------------------------------------
# Do not modify the exit
# ----------------------------------------------------------------------------------
exit:                     
  addi $v0, $0, 10              # system call (10) exits the program
  syscall                       # exit the program
