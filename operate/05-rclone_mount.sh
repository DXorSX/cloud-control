#!/bin/bash

source ../ENVSETTINGS

if [ ! -d $RCLONEMNT ]; then
	mkdir $RCLONEMNT
fi

rclone mount --daemon \
	--config=$RCLONEINI \
	--vfs-cache-mode writes \
	--vfs-cache-max-size 250M \
	gTeamdriveSecure2: $RCLONEMNT
	
