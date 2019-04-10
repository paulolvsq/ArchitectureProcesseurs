#!/bin/bash

  echo "=== $1 ==="
  /users/Enseignants/bazargan/archi/Linux/bin/asm -set noreorder -s $1.sym -ld mips32_ld -mips32 -o $1.mem $1.u std_m.u std_m.x std_m.r
