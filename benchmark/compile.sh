#!/bin/sh
compile_cobol_source(){
    SOURCE=$1
    echo "Transpilation to C using cobc ***************************************"
    cobc -C -x "$SOURCE.cbl"
    echo "Compile to llvm bytcode using graal *********************************"
    gu-clang "$SOURCE.c" -S -o "bin/$SOURCE.ll" -emit-llvm
}
mkdir -p bin;
for PROGRAM in "mandelbrotset" "factorial" "sieveoferathostenes" "fibonacci"
do
    echo "$PROGRAM"
	compile_cobol_source $PROGRAM;
done
