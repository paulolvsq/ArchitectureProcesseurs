.text : 

	ori $2 $4 0
	ori $6 $0 'z'
	j test
	
	 while : 
	 	
	 	 slti $7 $5 'a'
	 	 slt $8 $6 $5
	 	 or $8 $8 $7
	 	 bne $8 $0 endif
	 	 addi $5 $5 'A'-'a'
	 	 sb $5 0($4)
	 	 
	endif : 
		
		 addiu $4 $4 1

	test : 
		
		 lb $5 0($4)
		 bne $5 $0 while
		 
		  jr $31 