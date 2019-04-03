.text :

	strlen : 
		ori $2 $0 0
	while :
		lb $5 0($4)
		beq $5 $0 endwhile
		addi $2 $2 1
		addiu $4 $4 1
	endwhile : 
		jr $31