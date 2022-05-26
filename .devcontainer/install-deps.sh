#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

echo "Update and install system deps:"

sudo apt update && sudo apt install -y direnv


echo "Installing the Anagolay CLI"
sudo sh -c 'curl https://bafybeibybur764gvodwjpzij4umjzr6knkpfcnil5sdmwfoysyfgi5gvre.ipfs.anagolay.network > /usr/local/bin/anagolay && chmod +x /usr/local/bin/anagolay'

# smoke test
echo "Anagolay version is $(anagolay --version)"

if [ ! -f "$HOME/.bashrc.d/custom" ]; then
if [ ! -d "$HOME/.bashrc.d" ]; then
  mkdir $HOME/.bashrc.d
  else 
  # this is not used in the vscode but we don't want to echo eval all the time. it's quick and dirty trick
  mkdir $HOME/.bashrc.d
  echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
  fi

	echo "Linking the custom bashrc file"
	ln -sf $PROJECT_ROOT/.devcontainer/custom_bashrc $HOME/.bashrc.d/custom 
fi

if [ ! -d "$PROJECT_ROOT/operations/op_file" ]; then
	echo "Cloning the Op_File to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_file.git $PROJECT_ROOT/operations/op_file
fi

if [ ! -d "$PROJECT_ROOT/operations/op_multihash" ]; then
	echo "Cloning the Op-Multihash to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_multihash.git $PROJECT_ROOT/operations/op_multihash 
fi

if [ ! -d "$PROJECT_ROOT/operations/op_cid" ]; then
	echo "Cloning the Op-cid to the root for testing"
	git clone https://gitlab.com/anagolay/operations/op_cid.git $PROJECT_ROOT/operations/op_cid 
fi

# install pnpm
echo "Installing pnpm"
npm install -g pnpm
