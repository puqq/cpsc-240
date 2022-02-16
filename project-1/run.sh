#!/bin/bash

#Author: Daniel C
#Title: BASH compile for C++

rm *.o
rm *.out

echo "Compiling files..."

nasm -f elf64 -o triangle.o triangle.asm

g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o area.o area.cpp

g++ -g -m64 -std=c++17 -fno-pie -no-pie -o application.out triangle.o area.o

if test -f "application.out"; then
    echo "Compilation successful. Running program."
    ./application.out
else
    echo "Can't find compiled program. Build failed?"
fi
