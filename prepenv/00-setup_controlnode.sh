#!/bin/bash

OSARCH=$(uname -m)

case "$OSARCH" in
x86_64)         PKGARCH=amd64 ;;
armv6l)         PKGARCH=armv6 ;;
armv7l)         PKGARCH=armv7 ;;
aarch64)        PKGARCH=arm64 ;;
i386|i686)      PKGARCH=386   ;;
esac

case "$OSTYPE" in
darwin19)		PKGOS=macos		;;
linux-gnu*)		PKGOS=linux 	;;
FreeBSD)		PKGOS=freebsd 	;;
esac

if [ -n "$OSTYPE" ] && command -v wget $> /dev/null; then
	echo "Running OS is ${PKGOS^^}, continuing to install hcloud";
  	mkdir ~/hcloud
	wget -c https://github.com/hetznercloud/cli/releases/latest/download/hcloud-$PKGOS-$PKGARCH.tar.gz -O - | tar -xzf - -C ~/hcloud hcloud
	exit 0
fi
echo "ERROR: You are runninng an unsupported OS (only Linux, MacOS, FreeBSD are supported) or need to install the *wget* command"
exit 1