#!/bin/bash

# Environemnt vars
source ../ENVSETTINGS
LUKSPW=$1


echo "Checking Container Directory ..."
if [ -d "$CONTAINERDIR" ]; then
	echo -e "   ${GREEN}OK${NC} - $CONTAINERDIR already exists."
else
	echo -e "   ${RED}not found${NC} - $CONTAINERDIR not found!"
	mkdir "$CONTAINERDIR";
fi

echo "Checking vault files ..."
if [ -e $CONTAINERDIR/$INICONTAINER ]; then
	echo -e "   ${GREEN}OK${NC} - $INICONTAINER already exists!"
	echo "   trying to unlock $INICONTAINER"
	echo "$LUKSPW" | sudo cryptsetup luksOpen $CONTAINERDIR/$INICONTAINER $INICONTAINERLOOPDEV -d -
	echo "   trying to mount into $INICONTAINERMNT"
	if [ ! -d "$INICONTAINERMNT" ]; then
		mkdir -p "$INICONTAINERMNT"
	fi
	mount -t ext4 /dev/mapper/$INICONTAINERLOOPDEV $INICONTAINERMNT
else
	echo -e "   ${RED}not found${NC} - $INICONTAINER not found, please copy to $CONTAINERDIR"
	exit
fi


if [ -e $CONTAINERDIR/$DATACONTAINER ]; then
        echo -e "   ${GREEN}OK${NC} - $DATACONTAINER already exists!" 
	echo "   trying to unlock $DATACONTAINER"
        echo $LUKSPW | sudo cryptsetup luksOpen $CONTAINERDIR/$DATACONTAINER $DATACONTAINERLOOPDEV -d -
        echo "   trying to mount into $DATACONTAINERMNT"
		if [ ! -d "$DATACONTAINERMNT" ]; then
			mkdir -p "$DATACONTAINERMNT"
		fi
        mount -t ext4 /dev/mapper/$DATACONTAINERLOOPDEV $DATACONTAINERMNT
	if [ ! -d $DATACONTAINERMNT/NZBs ]; then
		mkdir $DATACONTAINERMNT/NZBs
	fi
else
        echo -e "   ${RED}not found${NC} - $DATACONTAINER not found, please copy to $CONTAINERDIR"
	exit
fi


