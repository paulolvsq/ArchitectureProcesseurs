.data :

tableau : .word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
size : .word 10

.text :

partition :

	ori 	$3 	$4 	0 #deuxieme index
	ori 	$2 	$0 	0 # adresse de retour dans $2
	lw 	$6 	(0)$4 # p = tab[0]
	sll 	$5 	$5 	2
	addiu 	$5 	$5 	$4
	j test

for :

	lw 	$8 	0($4) # t[i]
	slt 	$9 	$8 	$6
	beq 	$9 	$0 	endif
	addi 	$2 	$3 	1
	addiu 	$3 	$3 	4 #index++
	lw 	$10 	0($3) # *(t+index)
	sw 	$8 	0($3)
	sw 	$10 	0($4)

endif :

	addiu 	$4 	$4 	4

test :

	sltu 	$9 	$4 	$5
	bne 	$9 	$0 	for
	lw 	$10 	0($3)
	sw 	$10 	0($7)
	sw 	$6 	0($3)

	jr 	$31

quicksort :

	addiu 	$29 	$29	-4*4
	sw 	$31		3*4($29)

	sw 	$4	0($29)
	sw 	$5	4($29)
	
	ori 	$6 	$0 	1
	slt 	$7 	$6 	$5
	beq	$7	$0	end_if_quicksort
	jal 	partition
	
	sw	$2	2*4($29)
	lw 	$4	0($29)
	lw	$5	2*4($29)
	jal 	quicksort

	lw	$7	2*4($29)
	addi 	$7	$7	1
	lw 	$5	4*4*4($29)
	sub 	$5 	$5 	$7
	sll	$7	$7	2
	lw	$4	4*4+0($29)
	addu	$4	$4	$7
	jal 	quicksort

end_if_quicksort :
	
	lw	$31	3*4($29)
	addiu 	$29	$29	4*4
	jr	$31
	
