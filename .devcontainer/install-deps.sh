#!/usr/bin/env bash

echo "Installing the Anagolay CLI"
sudo sh -c 'curl https://bafybeiawp434qdc6slnxn4dssvzorywjg2xvp3lojuw25y6fna3z2vq3py.ipfs.anagolay.network > /usr/local/bin/anagolay && chmod +x /usr/local/bin/anagolay'

# smoke test
echo "Anagolay version is $(anagolay --version)"

if [ ! -d "/workspace/op_file" ]; then
	echo "Cloning the Op_File to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_file.git 
fi

if [ ! -d "/workspace/op_multihash" ]; then
	echo "Cloning the Op-Multihash to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_multihash.git 
fi

if [ ! -d "/workspace/op_cid" ]; then
	echo "Cloning the Op-cid to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_cid.git 
fi

# extract the cjs workflow to use as dependency
if [ ! -d "/tmp/wf_file_multihash_cid_wasm" ]; then
	echo "Unzipping the workflow wasm to the root for testing"
	curl -o cjs.tar.gz "https://ipfs.anagolay.network/ipfs/bafybeidws5rdgvj5ycqhbumf6yfm2w2rcwmc7xs3uprtyy23rdmp54cw4q"
  mkdir /tmp/wf_file_multihash_cid_wasm
  tar -xzf cjs.tar.gz -C /tmp/wf_file_multihash_cid_wasm
  rm -f cjs.tar.gz
fi

# install pnpm
echo "Installing pnpm"
npm install -g pnpm
