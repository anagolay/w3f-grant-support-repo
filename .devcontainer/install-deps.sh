#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)


echo "Installing the Anagolay CLI"
sudo sh -c 'curl https://bafybeiawp434qdc6slnxn4dssvzorywjg2xvp3lojuw25y6fna3z2vq3py.ipfs.anagolay.network > /usr/local/bin/anagolay && chmod +x /usr/local/bin/anagolay'

# smoke test
echo "Anagolay version is $(anagolay --version)"

if [ ! -d "/workspace/operations/op_file" ]; then
	echo "Cloning the Op_File to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_file.git /workspace/operations/op_file
fi

if [ ! -d "/workspace/operations/op_multihash" ]; then
	echo "Cloning the Op-Multihash to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_multihash.git /workspace/operations/op_multihash 
fi

if [ ! -d "/workspace/operations/op_cid" ]; then
	echo "Cloning the Op-cid to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_cid.git /workspace/operations/op_cid 
fi

# install pnpm
echo "Installing pnpm"
npm install -g pnpm

echo "Installing nodejs demo deps"
cd $PROJECT_ROOT/demos/nodejs
pnpm install


echo "Installing rust demo deps"
cd $PROJECT_ROOT/demos/rust
cargo fetch
