#!/bin/bash

for s in 0.5 1. 2. 3. 4. 5.
do
  for b in 2. 20. 200. 2000.
  do
    julia ~/Documents/stage/Chaincoeffs/ChainOhmT.jl $s $b
  done
done
