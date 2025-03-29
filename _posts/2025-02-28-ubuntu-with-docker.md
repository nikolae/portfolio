---
layout: page
title:  "Ubuntu Server and Docker"
teaser: "Containerize all the things"
date:   2025-02-28 07:00:01 -0700
categories: web software server
tags: software self-host docker proxmox portainer
published: true
header: no
---

I'm not new to the world of virtualization, but I am new to the world of Docker, Portainer, and Kubernetes. I recently built a new app server and put ProxMox on it to act as my hypervisor. Here's how I setup Docker.

In ProxMox, create a new VM in the administration panel. Proceed through the steps to install Ubuntu server. You can download the ISO from Canonical and store it on either one of the attached drives in ProxMox or something like a NAS. For a smaller footprint, choose the minimized install option.

Once installed, assuming a Debian-based distro, run the usual 
`apt update`
`apt upgrade -y`
Reboot for health and take a fresh post-install snapshot.

Next, install Docker (Portainer is dogfooding Docker and is a Docker image itself): `apt install docker.io -y`
Install portainer: `docker pull portainer/portainer-ce:latest`
Next, run the image: `docker run -d -p 9443:9443 --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce:latest`
These switches will have it start automatically and bind the ports on the VM.

Done! Access the portainer interface at `http://<your-VM-IP>:9443`
