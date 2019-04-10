#!/bin/bash

  source ENV.csh
  echo "==== $1 ===="

  sed -e '/=/d' -e 's/ / : /' ../asm/$1.mem > ram.ini
  /users/Enseignants/bazargan/archi/Linux/bin/simulad -l 1 -p 50 -nostrict -bdd -nores -sx ram_cpu_m_1_0 ram_cpu_m_1_0
  /bin/rm ram.ini
