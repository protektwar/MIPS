.data

pattern: 	.space 17	# array of 16 (1 byte) characters (i.e. string) plus one additional character to store the null terminator when N=16

N_prompt:	.asciiz "Enter the number of bits (N): "
newline: 	.asciiz "\n"

.text

main:


#----------------------------------------------
#
# Fully Functional C Code for reference
#
# include<stdio.h>
# char pattern[17] = {0};
# void bingen( unsigned int N, unsigned int n );
#
# int main( int argc, char** argv ) {
#
#	 unsigned int N = 0;
#	 // You can assume the user enters a
#	 // value of N >= 1 and N <= 16.
#	 // i.e. no error checking is necessary
#	 printf( "Enter the number of bits (N): ");
#	 scanf("%u", &N );
# 
#	 unsigned int n = N;
#	 pattern[N] = '\0'; // Null terminate the string
#	 bingen( N, n );
#	 return 0;
# }
#
# void bingen( unsigned int N, unsigned int n ) {
#    if ( n > 0 ) {
#        pattern[N-n] = '0';
#        bingen( N, n - 1 );
#        pattern[N-n] = '1';
#        bingen( N, n - 1 );
#    } else printf( "%s\n", pattern );
# }
#
#----------------------------------------------


# TODO: Main Program

	add $s1, $0, $0				# unsigned int N = 0;
	
	addi $v0, $0, 4  			# System call (4) to print string.
	la $a0, N_prompt		        # Put string memory address in register $a0.
	syscall           			# Print string.
	
	addi $v0, $0, 5				# System call (5) to get integer from user and store in register $v0.
	syscall					# Get user input for variable "size".
	add $s2, $0, $v0			# Copy to register $s1, b/c we'll reuse $v0.
	
	add $s1, $s2, $0			#unsigned int n = N;

	add $t0, $0, $0
	la $t1, pattern
	add $t2, $s2, $t1
	sb $t1, 0($t2)                        # pattern[N] = '\0'; // Null terminate the string
	
	add $a0, $0, $s2
	add $a1, $0, $s1
	jal bingen

	j exit

bingen:				
# TODO: Recursive Function
        #save stack
        addi $sp, $sp, -8                       #stack compare strings
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        addi $fp, $sp, 4

        addi $sp, $sp, -12
        sw $t0, 8($sp)
        sw $t1, 4($sp)
        sw $t2, 0($sp)
        
        
        add $t0, $0, $a0                        # N
        add $t1, $0, $a1                        # n
        la  $t2, pattern
        
	slt $s3,$0,$t1			#if ( n > 0 ) {
	beq $s3, 1,ifThen 
	b ifElse
	
ifThen:	
        sub $t3, $t0, $t1
        li  $t4, '0'
        add $t5, $t3, $t2
        sb  $t4, 0($t5)                 # pattern[N-n] = '0';
        
	add $a0, $0, $t0
	add $a1, $0, $t1
	addi $a1, $a1, -1               # n - 1
        jal bingen                      # bingen( N, n - 1 );

        sub $t3, $t0, $t1
        li  $t4, '1'
        add $t5, $t3, $t2
        sb  $t4, 0($t5)                 # pattern[N-n] = '1';

	add $a0, $0, $t0
	add $a1, $0, $t1
	addi $a1, $a1, -1               # n - 1
        jal bingen                      # bingen( N, n - 1 );
        
        j exit_bingen

ifElse:

        la   $a0, pattern
        addi $v0, $0, 4
        syscall
        
        li $a0, '\n'
        addi $v0, $0, 11
        syscall
                                        # printf( "%s\n", pattern )
        
exit_bingen:
        #restore stack
        lw $t2, -16($fp)
        lw $t1, -12($fp)
        lw $t0, -8($fp)

        addi $sp, $fp, 4
        lw $ra, 0($fp)
        lw $fp, -4($fp)        
	jr $ra	

exit:                     
  addi $v0, $0, 10      	# system call code 10 for exit
  syscall               	# exit the program
