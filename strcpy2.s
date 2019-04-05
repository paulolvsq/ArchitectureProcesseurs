.text :

strcpy :

  ori $2 $4 0

while :

  lb $6 0($5)
  beq $6 $0 end_while
  sb $4 0($6)
  addi $4 $4 1
  addi $5 $5 1
  j while

end_while :

  jr $31

