#!/bin/bash

source ../ENVSETTINGS
LUKSPW=$1

echo "Checking Container Directory ..."
if [ -d "$CONTAINERDIR" ]; then
	echo -e "   ${GREEN}OK${NC} - $CONTAINERDIR already exists."
else
	echo -e "   ${RED}not found${NC} - $CONTAINERDIR not found!"
	mkdir "$CONTAINERDIR"
fi




echo "Checking vault files ..."
if [ -e $CONTAINERDIR/$INICONTAINER ]; then
	echo -e "   ${GREEN}OK${NC} - $INICONTAINER already exists, nothing to do"
else
	echo -e "   ${RED}not found${NC} - $INICONTAINER not found, will create vaults in $CONTAINERDIR"
	dd if=/dev/urandom bs=1M count=50 | pv | dd of="$CONTAINERDIR/$INICONTAINER"
	echo "$LUKSPW" | sudo cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -y luksFormat "$CONTAINERDIR/$INICONTAINER" -d -
	echo -e "   ${GREEN}OK${NC} - $INICONTAINER created, creating filesystem within the container"
	echo "$LUKSPW" | sudo cryptsetup luksOpen "$CONTAINERDIR/$INICONTAINER" "$INICONTAINERLOOPDEV" -d -
	sudo mkfs.ext4 "/dev/mapper/$INICONTAINERLOOPDEV"
	echo -e "   ${GREEN}OK${NC} - filesystem created. Creating mountpoint."
	mkdir -p "$INICONTAINERMNT"
fi


if [ -e $CONTAINERDIR/$DATACONTAINER ]; then
        echo -e "   ${GREEN}OK${NC} - $DATACONTAINER already exists, nothing to do"
else
	echo -e "   ${RED}not found${NC} - $DATACONTAINER not found, will create vaults in $CONTAINERDIR"
	#dd if=/dev/urandom bs=1M count=15000 | pv | dd of="$CONTAINERDIR/$DATACONTAINER"
	dd if=/dev/urandom bs=1G count=0 seek=70 of="$CONTAINERDIR/$DATACONTAINER" # Using sparse file
	echo "$LUKSPW" | sudo cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -y luksFormat "$CONTAINERDIR/$DATACONTAINER" -d -
	echo -e "   ${GREEN}OK${NC} - $DATACONTAINER created, creating filesystem within the container"
	echo $LUKSPW | sudo cryptsetup luksOpen "$CONTAINERDIR/$DATACONTAINER" "$DATACONTAINERLOOPDEV" -d -
	sudo mkfs.ext4 "/dev/mapper/$DATACONTAINERLOOPDEV"
	echo -e "   ${GREEN}OK${NC} - filesystem created. Creating mountpoint."
	mkdir -p "$DATACONTAINERMNT"
fi
