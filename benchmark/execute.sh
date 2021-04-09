#!/bin/bash
execute_cobol_program(){
    EXECUTABLE=$1
    echo "LLVM ***************************************************************"
    bash -c "time /opt/llvm-project-llvmorg-10.0.0/build/bin/lli -load /usr/local/lib/libcob.so ./bin/$EXECUTABLE.ll | grep m.*s"
    echo "GRAAL LLVM *********************************************************"
    bash -c "time /opt/graalvm-ce-java11-21.0.0.2/lib/llvm/bin/lli -load /usr/local/lib/libcob.so ./bin/$EXECUTABLE.ll | grep m.*s"
}
for PROGRAM in "mandelbrotset" "factorial" "sieveoferathostenes" "fibonacci"
do
    printf "\n%s>\n" $PROGRAM
	execute_cobol_program $PROGRAM;
done
