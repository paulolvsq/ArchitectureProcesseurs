.text :

strlen :

  ori     $2    $0    0

while :

  lb      $5    0($4)
  beq     $5    $0    end_while
  addi    $2    $2    1
  addi    $4    $4    1
  j       while

end_while :

  jr      $31
