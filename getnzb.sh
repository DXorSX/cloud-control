#!/bin/bash

#### Change your key ####
LUKSPW=SetYourOwnKey # <<-- Change this!
#########################

SERVERNAME=test001
SERVERTYPE=cx31
INICONTAINER=inicontainer.vault
NZBREMOTEDROPFOLDER=/root/mount/gTeamdriveSecure
SSHPUBKEY=~/.ssh/hetzner_key.pub
SSHPRIVKEY=~/.ssh/hetzner_key
SRVSTATUS=`hcloud server list -o columns=status -o noheader`
HCCONTEXT=`hcloud context active`

if [ "$LUKSPW" = "SetYourOwnKey" ]; then
	echo "Key for LUKS Container ist not set."
	echo "Open $0 an edit LUKSPW Variable"
	exit 1
fi

if [ ! -r "$SSHPRIVKEY" ]; then
	echo "SSH Key does not exist"
	echo "Generating Key ..."
	ssh-keygen -t rsa -N "" -f "$SSHPRIVKEY"
fi

if [ "$HCCONTEXT" = "" ]; then
	echo "hcloud context not set, please run: hcloud context create"
fi


echosyntax ()
{
        echo "Syntax: $0 [/path/file.nzb]"
}

if [ "$SRVSTATUS" = "running" ]; then
	IPv4=`hcloud server ip $SERVERNAME`
	echo "Cloud node is still running with ip: $IPv4"
	if [ -r "$1" ]; then
		echo "sending NZB to server"
		scp "$1" root@$IPv4:"$NZBREMOTEDROPFOLDER"
		exit	
	else
		echo "NZB File needed"
		echosyntax
		exit
	fi
fi

hcloud server create --type $SERVERTYPE --name "$SERVERNAME" --image debian-10 --ssh-key $SSHPUBKEY --datacenter fsn1-dc14
IPv4=`hcloud server ip $SERVERNAME`

ssh-keygen -R "$IPv4"

SSHUP=255
while [ $SSHUP != 0 ]; do
	sleep 1
	echo "Trying to connect ..."
	ssh -l root -o="StrictHostKeyChecking off" $IPv4 pwd
	SSHUP=$?
done

ssh -l root "$IPv4" "mkdir -pv /root/cryptcontainer/"
if [ -r "$INICONTAINER" ]; then
	scp ./"$INICONTAINER" root@"$IPv4":/root/cryptcontainer/
fi

ssh -l root "$IPv4" "apt --yes update && \
	apt --yes install git && \
	cd /root && \
	git clone https://github.com/DXorSX/cloud-control.git && \
	cd /root/cloud-control/ && \
	/root/cloud-control/run.sh $LUKSPW"

if [ -r "$1" ]; then
		echo "sending NZB to server"
		scp "$1" root@$IPv4:"$NZBREMOTEDROPFOLDER"
		exit	
else
		echo "NZB File needed"
		echosyntax
		exit
fi



