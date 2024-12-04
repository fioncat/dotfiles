#!/bin/bash

go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/koron/iferr@latest

rustup toolchain install stable
rustup component add clippy
rustup component add rust-analyzer
rustup component add rust-src

# Install roxide
curl --fail --location -o roxide.tgz https://github.com/fioncat/roxide/releases/latest/download/roxide-x86_64-unknown-linux-gnu.tar.gz
tar -xzvf roxide.tgz
mkdir -p bin
mv roxide bin/roxide
rm roxide.tgz
