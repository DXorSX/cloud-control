#!/bin/bash

source ../ENVSETTINGS
APTINSTALL=""

echo "Docker ..."
if [ ! -x /usr/bin/docker ]; then
	echo -e "   ${RED}not found${NC} - starting installation!"
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh > /dev/null
else
	echo -e "  ${GREEN}OK${NC} - already installed."
fi

echo "rclone ..."
if [ ! -x /usr/bin/rclone ]; then
	echo -e "   ${RED}not found${NC} - starting installation!"
	curl https://rclone.org/install.sh | sudo bash > /dev/null
else
	echo -e "  ${GREEN}OK${NC} - already installed."
fi

echo "OpenVPN ..."
if [ ! -x /usr/sbin/openvpn ]; then
	echo -e "   ${RED}not found${NC} - starting installation!"
	# sudo apt --yes install openvpn
	APTINSTALL="$APTINSTALL openvpn"
else
	echo -e "  ${GREEN}OK${NC} - already installed."
fi

echo "cryptsetup ..."
if [ ! -x /usr/sbin/cryptsetup ]; then
	echo -e "   ${RED}not found${NC}, starting installation!"
	# sudo apt --yes install cryptsetup
	APTINSTALL="$APTINSTALL cryptsetup"
else
	echo -e "  ${GREEN}OK${NC} - already installed."
fi

echo "pv ..."
if [ ! -x /usr/bin/pv ]; then
	echo -e "   ${RED}not found${NC}, starting installation!"
	# sudo apt --yes install pv
	APTINSTALL="$APTINSTALL pv"
else
    echo -e "  ${GREEN}OK${NC} - already installed."
fi

echo "fusermount ..."
if [ ! -x /usr/bin/fusermount ]; then
	echo -e "   ${RED}not found${NC}, starting installation!"
	# sudo apt --yes install fuse
	APTINSTALL="$APTINSTALL fuse"
else
        echo -e "  ${GREEN}OK${NC} - already installed."
fi

sudo apt --yes install $APTINSTALL


