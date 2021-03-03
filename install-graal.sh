#!/bin/sh
# Go to /opt directory
cd /opt || exit
# Download and extract compiled GraalVM
wget graalvm-ce-java11-21.0.0.2.tar.gz
tar xz graalvm-ce-java11-21.0.0.2.tar.gz
# Create GraalVM symlink in /usr/bin
ln -s /opt/graalvm-ce-java11-21.0.0.2/bin/gu /usr/bin/gu
# Install GraalVM LLVM pakcage
gu install llvm-toolchain
# Create GraalVM Clang and LLVM Interpreter symlink in /usr/bin
ln -s /opt/graalvm-ce-java11-21.0.0.2/bin/lli /usr/bin/gu-lli
ln -s /opt/graalvm-ce-java11-21.0.0.2/bin/clang /usr/bin/gu-clang