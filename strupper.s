.text :

strupper :

  ori     $2    $4    0

while :

  lb      $5    0($4)
  beq     $5    $0    end_while

if :

  slti    $6    $5    'a'
  slti    $7    $5    'z'+1
  beq     $7    $0    end_if
  bne     $6    $0    end_if
  addi    $5    $5    'A'-'a'
  sb      $5    0($4)

end_if :

  addi    $4    $4    1
  j       while

end_while :

  jr      $31
