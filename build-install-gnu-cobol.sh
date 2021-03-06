#!/bin/sh
# Download GNU CoBOL from Github
git clone https://github.com/ayumin/open-cobol.git
# Configure compilation with Clang from GraalVM
cd open-cobol || exit
./configure --with-cc=gu-clang --without-db
# Compile and install GNU Cobol
sudo make install