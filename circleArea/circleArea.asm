.data
    pi: .double 3.14   # float representing pi
    
.text
    #la $t0, pi    
    #l.d  $f8, 0($t0) # f8=3.14
    lwc1 $f8, pi
    
    li $v0, 7
    syscall
    mul.d $f2, $f0, $f0 # sqaures the radius, r*r=r^2
    
    
    li $v0, 2
    mul.d $f12, $f8, $f2 # f12=the area=pi*r^2
    syscall # prints the radius
