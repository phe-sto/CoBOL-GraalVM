#!/bin/sh
# Configure build
sh ./autogen.sh
./configure --with-cc=gu-clang --without-db
# Compile and install GNU Cobol
sudo make install