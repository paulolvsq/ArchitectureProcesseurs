.data 

	src : .asciiz "test"
	trg : .space 5

.text :
	strcopy : 
	
		ori $2 $4 0 
	
	while : 
		
		lb $6 0($5)
		sb $6 0($4)
		addiu $5 $5 1
		addiu $4 $4 1
		
	test : 
	
		bne $6 $0 while
	
	endwhile :
	
		 jr $31

		
		