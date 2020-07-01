#!/bin/bash

source ./ENVSETTINGS
LUKSPW=$1

cd /root/cloud-control/prepenv/ 
	./00-setup_controlnode.sh 
	./10-setup_node.sh
    ./20-setup_crypt_container.sh $LUKSPW
cd /root/cloud-control/operate/
	./00-crypt_container.sh $LUKSPW
	./05-rclone_mount.sh
	./10-run_sabnzbd_docker.sh


	
