#!/bin/bash

base=$(pwd)
for((i=0; i<10; i++)); do
  cd ${base}
  index="00000${i}"
  index=${index: -4}
  work="job-${index}"
  cp -rp /home/wang/schrodinger/geopt/src ${work}
  cd ${work}
  jaguar run -HOST localhost -PARALLEL 8 -NOJOBID -WAIT -t -scr /tmp/$$ geopt.in > stdout.log 2>&1 
done

