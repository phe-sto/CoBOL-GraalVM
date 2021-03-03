#!/bin/sh
# Go to /opt directory
cd /opt || exit
# Download and extract compiled LLVM
wget https://github.com/llvm/llvm-project/archive/llvmorg-10.0.0.zip
unzip llvmorg-10.0.0.zip -d .
# Prepare build directory
mkdir build
cd build || exit
# Configure Ninja build for a release build whithout assertion
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=off
ninja
# Create LLVM Interpreter symlink in /usr/bin
sudo ln -s /opt/llvm-project-llvmorg-10.0.0/build/bin/ll /usr/bin/lli