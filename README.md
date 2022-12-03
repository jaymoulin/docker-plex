![logo](logo.png)

Plex Media Server - Docker Image (Multiarch + Raspberry Pi)
===

[![latest release](https://img.shields.io/github/release/jaymoulin/docker-plex.svg "latest release")](http://github.com/jaymoulin/docker-plex/releases)
[![Follow on twitter](https://img.shields.io/twitter/follow/DockerPlex.svg?style=social&label=Follow "Follow on twitter")](https://twitter.com/DockerPlex)
[![Docker Pulls](https://img.shields.io/docker/pulls/jaymoulin/plex.svg)](https://hub.docker.com/r/jaymoulin/plex/)
[![Docker stars](https://img.shields.io/docker/stars/jaymoulin/plex.svg)](https://hub.docker.com/r/jaymoulin/plex/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jaymoulin/rpi-plex.svg)](https://hub.docker.com/r/jaymoulin/plex/)
[![Docker stars](https://img.shields.io/docker/stars/jaymoulin/rpi-plex.svg)](https://hub.docker.com/r/jaymoulin/plex/)
[![PayPal donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/ppl.png "PayPal donation")](https://www.paypal.me/jaymoulin)
[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png "Buy me a coffee")](https://www.buymeacoffee.com/jaymoulin)
[![Buy me a coffee]([https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_dark.png](https://storage.ko-fi.com/cdn/kofi2.png) "Buy me a coffee")](https://www.ko-fi.com/jaymoulin)

DISCLAIMER: As-of 2021, this product does not have a free support team anymore. If you want this product to be maintained, please support on Patreon.

(This product is available under a free and permissive license, but needs financial support to sustain its continued improvements. In addition to maintenance and stability there are many desirable features yet to be added.)

This image allows you to configure a Plex Media Server easily thanks to Docker.

Installation
---

First, you have to mount your USB drive.
```
sudo mount /dev/sda1 /mnt/usbdrive
```

*Important Note*

Don't forget to mount the Plex Library directory local folder to `/root/Library` folder.

Example :

```
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media --net=host -v /mnt/usbdrive:/root/Library jaymoulin/plex

```

This will start Plex using your mounted drive in /media path in Plex.

```
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media --net=host jaymoulin/plex
```

Configuration
---

Go to http://__your_machine_ip__:32400/manage to configure it


Appendixes
---

### Install Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

### Known issues

#### libstdc++.so.6: cannot open shared object file

You will probably notice that kind of error log:
```
/usr/lib/plexmediaserver/Plex Tuner Service: error while loading shared libraries: libstdc++.so.6: cannot open shared object file: No such file or directory
/usr/lib/plexmediaserver/Plex Tuner Service: error while loading shared libraries: libstdc++.so.6: cannot open shared object file: No such file or directory
/usr/lib/plexmediaserver/Plex Tuner Service: error while loading shared libraries: libstdc++.so.6: cannot open shared object file: No such file or directory
```

This is a known issue for _Plex Tune Service ONLY_. 
This service is not required by Plex Media Server to work properly.
I have no intention to fix this log.
If you REALLY NEED Plex Tuner Service to work, please open an issue, or (better desired option), make a Pull Request to implement this feature.

#### Unknown file formats / "This server is not powerful enough to convert video"

Plex for Raspberry PI cannot read some video file format like AVI, WMV or OGM, either due to codec or due to RPI lack of power. You can convert them to make them compatible by using my docker image `jaymoulin/rpi-plex-video-converter` : https://github.com/jaymoulin/docker-rpi-plex-video-converter

#### How do I update?

Follow [@DockerPlex](https://twitter.com/DockerPlex) on Twitter to be alerted of updates!

