.data 

	a : .word 128
	b : .word 32

.text	
	
.globl _main

_main : 

	la	$4,	a
	lw	$4,	0($4)
	la	$5,	b
	lw	$5,	0($5)
	jal 	pgcd
	
	ori	$4	$2	0
	ori	$2	$0	1
	syscall
	
	ori	$2	$0	10
	syscall
	

pgcd : 

	ori	$2,	$4,	0
	j 	test

while :

	slt	$6,	$2,	$5
	beq	$6,	$0,	else
	sub	$5,	$5,	$2
	j end_if

else:

	sub	$2,	$2,	$5
	
test :
end_if :
	
	bne	$2,	$5,	while
	jr 	$31
	
	

	
		
