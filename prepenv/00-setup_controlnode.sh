#!/bin/bash

if [ "$OSTYPE" == "darwin19" ]; then
	BIN=`command -v brew`
	if [ -n "$BIN" ]; then
		echo "OS is MacOS, installing hcloud via homebrew";
		brew install hcloud;
	else
		echo "OS is MacOS, homebrew is need for autoinstall hcloud"
	fi
elif [ "$OSTYPE" == "linux-gnu" ]; then
	BIN=`command -v wget`
	if [ -n "$BIN" ]; then
                echo "OS is Linux, installing hcloud";
                mkdir ~/hcloud
		cd ~/hcloud
		wget https://github.com/hetznercloud/cli/releases/download/v1.16.2/hcloud-linux-amd64.tar.gz
		tar -zxvf hcloud-linux-amd64.tar.gz
        else
                echo "OS is Linux, wget not found";
        fi
fi
