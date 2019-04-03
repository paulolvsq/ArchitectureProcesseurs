.data :

	tableau : .word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
	size : .word 10

.text :
	
	partition :

	ori $3 $4 0 #deuxieme index
	ori $2 $0 0 # adresse de retour dans $2
	lw $6 (0)$4 # p = tab[0]
	sll $5 $5 2
	addiu $5 $5 $4
	j test

	for :

	lw $8 0($4) # t[i]
	slt $9 $8 $6
	beq $9 $0 endif
	addi $2 $3 1
	addiu $3 $3 4 #index++
	lw $10 0($3) # *(t+index)
	sw $8 0($3)
	sw $10 0($4)

	endif :

	addiu $4 $4 4

	test :

	slt $9 $4 $5
	bne $9 $0 for
	lw $10 0($3)
	sw $10 0($7)
	sw $6 0($3)

	jr $31
