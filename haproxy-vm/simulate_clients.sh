#!/bin/bash

# Execute a number of requests
let blues=0
let greens=0
for i in $(seq -f '%02g' 1 50); do
  wget localhost:8080 -O /tmp/html &> /tmp/wget.out
  if grep --silent 'Env: blue' /tmp/html; then 
    blues=$((blues+1))
  elif grep --silent 'Env: green' /tmp/html; then 
    greens=$((greens+1))
  else
    echo "Neither blue nor green, an error perhaps? See /tmp/html"
    echo "wget output:"
    cat /tmp/wget.out
    exit -1
  fi
done
echo ">> DONE; $blues served by blue, $greens served by green"
