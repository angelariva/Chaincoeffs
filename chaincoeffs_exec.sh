#!/bin/bash

for s in 0.5 1. 2. 3. 4. 5.
do
  julia ~/Documents/stage/Chaincoeffs/ChainOhmT.jl $s
done
