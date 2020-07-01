#!/bin/bash

source ../ENVSETTINGS

if [ ! -d "$DATACONTAINERMNT/NZBs" ]; then
	mkdir -pv "$DATACONTAINERMNT/NZBs"
fi

docker run -d \
	--name rclone-sabnzbd \
	-v $INICONTAINERMNT/sabnzbd:/config \
	-v $INICONTAINERMNT/rclone:/config/rclone \
	-v $DATACONTAINERMNT/incomplete:/incomplete \
	-v $DATACONTAINERMNT/complete:/complete \
	-v $RCLONEMNT/nzb-watchfolder:/NZBs \
	-p 127.0.0.1:8080:8080 \
	--user 0:0 \
	--restart=unless-stopped \
	dxorsx/rclone-sabnzbd

