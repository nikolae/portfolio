---
layout: page
title:  "Streaming Your Media"
teaser: "Streaming media"
date:   2025-03-29 07:00:01 -0700
categories: web software server
tags: software self-host jellyfin proxmox
published: true
header: no
---
<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

Continuing in my recent adventures with ProxMox, I've created a self-hosted streaming server. Nickflix, if you will. Here's how to recreate it:

# Installation
Create a new LXC in ProxMox using the latest LTS Debian release.

To temporarily use a password to ssh in instead of a key, edit `/etc/ssh/sshd_config` with nano and change `PermitRootLogin without-password` to `PermitRootLogin yes`.

Next, update apt and any installed packages:
`apt update -y && apt upgrade -y` (the -y automatically agrees to any prompts, usually size increase notices).

Install curl:
`apt install curl`

Install Jellyfin:
`curl https://repo.jellyfin.org/install-debuntu.sh | bash`

It should now be running, which you can access at `http://<your-local-ip>:8096`.

# Mounting Media
You now have a server running, but you need to point it to where your media files are located.

To mount media using an unpriveledged container:
1. SSH into the LXC
2. Create a group with `GID=10000` which matches the host `110000`:
`groupadd -g 10000 lxc_shares`
3. Add users:
`usermod -aG lxc_shares USER`
4. Shutdown the LXC and switch back to the host, then create a mount point, such as 
`mkdir -p /mnt/lxc_shares/my_nas`
5. Create a user and password with the appropriate permissions in your media server's user management.
6. Add SMB (CIFS) share to fstab:
`{ echo '' ; echo '# Mount CIFS share on demand with rwx permissions for use in LXCs (manually added)' ; echo '//NAS/nas/ /mnt/lxc_shares/my_nas cifs _netdev,x-systemd.automount,noatime,uid=100000,gid=110000,dir_mode=0770,file_mode=0770,user=smb_username,pass=smb_password 0 0' ; } | tee -a /etc/fstab`
7. Mount the share on the host:
`mount /mnt/lxc_shares/my_nas`
8. Add a bind mount of the share to the LXC config:
`{ echo 'mp0: /mnt/lxc_shares/nas_rwx/,mp=/mnt/nas,ro=1' ; } | tee -a /etc/pve/lxc/<LXC_ID>.conf`
9. Start the LXC. You should now see the NAS mounted in the `/mnt/nas` directory.

# Passing through the GPU
Transcoding is a useful way of serving media to devices that may not have native capability to decode, say, HDR content. GPUs are much better suited to this task, so to pass a GPU in your system to the media server we just created, follow these steps:

1. Open LXC to find the render GID and add 100,000 to it
`render:x:104:jellyfin` -> `100104`
2. Open the host and find the GPU device info (usually renderD128):
`ls -l /dev/dri`
![jellyfin](/assets/images/guides/jellyfin_GPU.png)
>GPU device info.
3. Open nano again and add the following to the LXC's conf making sure to use the noted number from earlier in the third line
`lxc.cgroup2.devices.allow: c 226:128 rwm`
`lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file`
`lxc.hook.pre-start: sh -c "chown 100000:100104 /dev/dri/renderD128"`
4. Back in the LXC, add the jellyfin account to the render group
`usermod -aG render jellyfin`
5. Finally, assuming you are using an Intel CPU with integrated GPU and quicksync support, install the appropriate package:
`apt install -y intel-opencl-icd`
6. Reboot the LXC, and that's it! SMB media shares and passthrough hardware decoding is now enabled on your LXC. Easy!

# Configure jellyfin
Even though we are passing through the GPU to the media server, we still need to tell the media server to utilize the device.

1. Under Dashboards > Playback > transcoding, select Intel QuickSync (QSV) hardware acceleration
2. Under QSV device, enter the default `/dev/dri/renderD128`
3. Set the hardware decoding as you see fit.
4. Enable VPP Tone mapping
5. Under transcode path, enter /dev/shm to use the server's RAM as a cache instead of the disk
6. Select a stereo downmix algorithm; I use `Dave750`.
I also set Throttle Transcodes and Delete segments, then the values to something like 300 and 720


# References
* [https://forum.proxmox.com/threads/guide-jellyfin-remote-network-shares-hw-transcoding-with-intels-qsv-unprivileged-lxc.142639/](https://forum.proxmox.com/threads/guide-jellyfin-remote-network-shares-hw-transcoding-with-intels-qsv-unprivileged-lxc.142639/)
* [https://forum.proxmox.com/threads/tutorial-unprivileged-lxcs-mount-cifs-shares.101795/](https://forum.proxmox.com/threads/tutorial-unprivileged-lxcs-mount-cifs-shares.101795/)