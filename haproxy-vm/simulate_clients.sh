#!/bin/bash

# Execute a number of requests
let blues=0
let greens=0
for i in $(seq -f '%02g' 1 50); do
  wget localhost:8080 -O html &> /dev/null &&  egrep '(blue|green)' html
  if grep --silent 'Env: blue' html; then blues=$((blues+1)); else greens=$((greens+1)); fi
done
echo ">> DONE; $blues served by blue, $greens served by green"
