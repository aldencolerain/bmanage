# bmanage
Tools to manage a Boring Man Game server

To setup Boring Man server on Ubuntu 14.04:

Install docker[https://docs.docker.com/engine/installation/linux/ubuntulinux/]

Ensure that you have forwarded ports 7778-7779 and 5900 if you want remote VNC access.

To start the default server container:
```
apt-get update && apt-get install git -y
git clone https://github.com/aldencolerain/bmanage && cd bmanage/servers
bash default/start.sh
```

To stop the default server container:
```
sudo docker stop boring
sudo docker rm boring
```