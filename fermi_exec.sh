#!/bin/bash

for s in 1.0 2.0
do
  for b in 2. 20. 200. 2000.
  do
    julia ~/Documents/stage/Chaincoeffs/ChainOhmT.jl $s $b
  done
done
