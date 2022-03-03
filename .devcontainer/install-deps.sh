#!/usr/bin/env bash

echo "Installing the Anagolay CLI"
sudo sh -c 'curl https://ipfs.anagolay.network/ipfs/bafybeia4ggdxxmrif357p6inwbuvzoxsavj24ol7h2cuvcnnnng7zgfqsi > /usr/local/bin/anagolay && chmod +x /usr/local/bin/anagolay'

# smoke test
echo "Anagolay version is $(anagolay --version)"

if [ ! -d "/workspace/op-file" ]; then
	echo "Cloning the Op-File to the root for testing"
	git clone https://gitlab.com/anagolay/op-file.git 
fi
