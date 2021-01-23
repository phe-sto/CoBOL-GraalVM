#!/bin/sh
cd /etc || exit
wget graalvm-ce-java11-linux-amd64-20.0.0.tar.gz
tar xz graalvm-ce-java11-linux-amd64-20.0.0.tar.gz
ln -s /etc/graalvm-ce-java11-20.0.0/bin/gu /usr/bin/gu
gu install llvm-toolchain
ln -s /etc/graalvm-ce-java11-20.0.0/bin/lli /usr/bin/lli-gu
ln -s /etc/graalvm-ce-java11-20.0.0/bin/clang /usr/bin/clang-gu