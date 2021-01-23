#!/bin/sh
compile_cobol_source(){
    SOURCE=$1
    echo "Transpilation to C using cobc *77444*********************************"
    cobc -C -x "$SOURCE.cbl"
    echo "Compile using cobc **************************************************"
    cobc -x "$SOURCE.cbl" -o "bin/$SOURCE-cobc"
    echo "Compile using clang *************************************************"
    clang "$SOURCE.c" -o "bin/$SOURCE-llvm" -lcob
    echo "Compile using gcc ***************************************************"
    gcc "$SOURCE.c" -o "bin/$SOURCE-gcc" -lcob
    echo "Compile to llvm bytcode using graal *********************************"
    clang-gu "$SOURCE.c" -o "bin/$SOURCE-graal.bc" -lcob
}
mkdir -p bin;
for PROGRAM in "mandelbrotset" "recursivefactorial" "sieveoferathostenes" "fibonacci15"
do
    echo "$PROGRAM"
	compile_cobol_source $PROGRAM;
done