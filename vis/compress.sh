#!/bin/sh
mkdir -p out_compressed/aes128_tb
mkdir -p out_compressed/aes256_tb
mkdir -p out_compressed/sha256_tb

cd out/aes128_tb
echo "out/aes128_tb"
find . -name "*.gif" -exec gifsicle -O3 --colors 256 {} -o ../../out_compressed/aes128_tb/{} \;
cd ../..

cd out/aes256_tb
echo "out/aes256_tb"
find . -name "*.gif" -exec gifsicle -O3 --colors 256 {} -o ../../out_compressed/aes256_tb/{} \;
cd ../..

cd out/sha256_tb
echo "out/sha256_tb"
find . -name "*.gif" -exec gifsicle -O3 --colors 256 {} -o ../../out_compressed/sha256_tb/{} \;
cd ../..
