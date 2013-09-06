#!/bin/bash

# Execute a number of requests
let blues=0
let greens=0
for i in $(seq -f '%02g' 1 50); do
  wget http://localhost:8080/js/deployment-bar.js -O webapp.out &> /tmp/wget.out
  if grep --silent 'zone: blue' webapp.out; then 
    blues=$((blues+1))
  elif grep --silent 'zone: green' webapp.out; then 
    greens=$((greens+1))
  else
    echo "Neither blue nor green, an error perhaps? See ./webapp.out"
    echo "wget output:"
    cat /tmp/wget.out
    exit -1
  fi
  rm webapp.out
done
echo ">> DONE; $blues served by blue, $greens served by green"
