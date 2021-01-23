#!/bin/sh
# Go to /etc directory
cd /etc || exit
# Download and extract compiled GraalVM
wget graalvm-ce-java11-linux-amd64-20.0.0.tar.gz
tar xz graalvm-ce-java11-linux-amd64-20.0.0.tar.gz
# Create GraalVM symlink in /usr/bin
ln -s /etc/graalvm-ce-java11-20.0.0/bin/gu /usr/bin/gu
# Install GraalVM LLVM pakcage
gu install llvm-toolchain
# Create GraalVM Clang and LLVM Interpreter symlink in /usr/bin
ln -s /etc/graalvm-ce-java11-20.0.0/bin/lli /usr/bin/lli-gu
ln -s /etc/graalvm-ce-java11-20.0.0/bin/clang /usr/bin/clang-gu