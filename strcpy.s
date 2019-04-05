.text :

strcpy :

  ori     $2    $4    0 #on met $4 dans l'adresse de retour

while :

  lb    $6    0($5) #on met dans $6 la valeur de src au byte 0
  beq   $6    $0    end_while
  sb    $4    0($6)
  addi  $4    $4    1
  addi  $5    $5    1
  j     while

end_while :

  jr $31
