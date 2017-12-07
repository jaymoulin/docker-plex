![logo](logo.png)

Plex Media Server - Docker Image (Multiarch)
===

[![latest release](https://img.shields.io/github/release/jaymoulin/docker-plex.svg "latest release")](http://github.com/jaymoulin/docker-plex/releases)
[![Follow on twitter](https://img.shields.io/twitter/follow/DockerPlex.svg?style=social&label=Follow "Follow on twitter")](https://twitter.com/DockerPlex)
[![Docker Pulls](https://img.shields.io/docker/pulls/jaymoulin/plex.svg)](https://hub.docker.com/r/jaymoulin/plex/)
[![Docker stars](https://img.shields.io/docker/stars/jaymoulin/plex.svg)](https://hub.docker.com/r/jaymoulin/plex/)
[![Bitcoin donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/btc.png "Bitcoin donation")](https://m.freewallet.org/id/374ad82e/btc)
[![Litecoin donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/ltc.png "Litecoin donation")](https://m.freewallet.org/id/374ad82e/ltc)
[![PayPal donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/ppl.png "PayPal donation")](https://www.paypal.me/jaymoulin)

This image allows you to configure a Plex Media Server easily thanks to Docker.

Installation
---

First, you have to mount your USB drive.
```
sudo mount /dev/sda1 /mnt/usbdrive
```

This will start Plex using your mounted drive
```
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media --net=host jaymoulin/plex
```

Configuration
---

Go to http://__your_machine_ip__:32400 to configure it

You can change the Plex Library directory by plugin your local folder to `/root/Library` folder 

Example :

```
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media --net=host -v /mnt/usbdrive:/root/Library jaymoulin/plex
```

Appendixes
---

### Install Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

### Unkonwn file formats / "This server is not powerful enough to convert video"

Plex for Raspberry PI cannot read some video file format like AVI, WMV or OGM, either due to codec or due to RPI lack of power. You can convert them to make them compatible by using my docker image `jaymoulin/rpi-plex-video-converter` : https://github.com/jaymoulin/docker-rpi-plex-video-converter

### New versions

Follow [@DockerPlex](https://twitter.com/DockerPlex) on Twitter to be alerted of updates!

