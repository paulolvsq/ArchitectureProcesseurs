.text:

strcmp:

  ori   $2    $0    0

while:

  lb    $6    0($4)
  lb    $7    0($5)
  or    $7    $7    $6
  beq   $7    $0    end_while
  bne   $2    $0    end_while
  sub   $2    $6    $7
  addi  $4    $4    1
  addi  $5    $5    1
  j     while

end_while:

  jr    $31

