#!/bin/bash

gcc -std=gnu99 -O2 -pedantic -fomit-frame-pointer -m64 -mtune=corei7-avx -march=corei7-avx -o gmp-chudnovsky gmp-chudnovsky.c -L/usr/local/lib/ -lgmp -lm
