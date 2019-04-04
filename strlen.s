.text :

strlen : # $4 = @str

  ori $2 $0 0 #on met len dans l'adresse de retour

while :

  lb $5 0($4) #on charge le premier byte dans $5
  beq $5 $0 end_while #si $5 == 0 j end_while
  addi $2 $2 1 #on incrémente la taille de 1
  addi $4 $4 1 #on incrémente la chaine de 1
  j while

end_while :

  jr $31
