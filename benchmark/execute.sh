#!/bin/bash
execute_cobol_program(){
    EXECUTABLE=$1
    echo "GCC *****************************************************************"
    bash -c "time ./bin/$EXECUTABLE-gcc | grep m.*s"
    echo "CLANG ***************************************************************"
    bash -c "time ./bin/$EXECUTABLE-llvm | grep m.*s"
    echo "COBC ****************************************************************"
    bash -c "time ./bin/$EXECUTABLE-cobc | grep m.*s"
    echo "GRAAL LLVM **********************************************************"
    bash -c "time lli-gu ./bin/$EXECUTABLE-graal.bc | grep m.*s"
}
for PROGRAM in "mandelbrotset" "recursivefactorial" "sieveoferathostenes" "fibonacci15"
do
    echo "$PROGRAM ************************************************************"
	execute_cobol_program $PROGRAM;
done