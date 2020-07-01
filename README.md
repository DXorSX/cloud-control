# cloud-control

This set of scripts will setup up a Linux Server in the [Hetzner Cloud](http://hetzner.cloud) and configure it for Usenet Downloads. 

## Requierments
* Account for [Hetzner Cloud](http://hetzner.cloud)
* Usenet Account
* Cloud Stroage (Google Drive, DropBox ..)
* Source for NZB Files
* Linux or Mac as control node

## How to start
* Install hcloud on your Linux or Mac machine and add a context (see Step 2 in [How-to: Hetzner Cloud CLI](https://community.hetzner.com/tutorials/howto-hcloud-cli))
* Download [getnzb.sh](https://github.com/DXorSX/cloud-control/blob/master/getnzb.sh) to your machine
  * Change the $LUKSPW in getnzb.sh
* Run getnzb.sh
  * the script will create a new ssh key in ~/.ssh/hetzner_key
  * and will create a server in the cloud
* Get the IP Adress of the new server by running `hcloud server list`
* Connect to the server: `ssh -l root [SERVER IP] -L 127.0.0.1:8080:127.0.0.1:8080`
* Configure rclone to access your Cloud Storage by running `rclone config`
  * Move the created rclone.conf to the configuration vault `mv ~/.ssh/.config/rclone/rclone.conf /root/mount/containerini/rclone/rclone.conf`
* Start your Browser an point to http://127.0.0.1:8080
  * Add your Usent Account to sabnzbd
  * Goto Settings/Folders configrue script folder as /config/rclone
* Reboot Server - This will umount the crypted containers
* Download the configuration vault: `scp root@[SERVER IP]:/root/cryptcontainer/inicontainer.vault .` 
* and place the inicontainer.vault in the same directory as getnzb.sh

Now your setup is complete (So simple!).
* Delete the created Server `hcloud server delete test001`. 
* Run `getnzb.sh /path/to/file.nzb` an let the magic happen.
* Have a look into your Cloud Storage, you will find the downloaded files/folders.

* After every run of getnzb.sh you can delete the server by running `hcloud server delete test001` an safe Money!
* If the Server is still runinning, run `getnzb.sh /path/to/anotherfile.nzb` the script will add the NZB to the sabnzbd queue

## ToDos'
- [ ] Optimze performance
- [ ] Create datacontainer.vault with dynamic size
- [ ] Cleanup Code
 
