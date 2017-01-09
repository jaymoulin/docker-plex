Raspberry PI - Plex Media Server - Docker Container
===

This container allow you to configure a Plex Media Server easily thanks to Docker.

Installation
---

First, you have to mount your USB drive.
```
sudo mount /dev/sda1 /mnt/usbdrive
```

This will start Plex using your mounted drive
```
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media -p 32400:32400 --net=host jaymoulin/rpi-plex
```

Configuration
---

Go to http://__raspberry_ip__:32400 to configure it

You can change the Plex Library directory by passing the changing the `PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR` environment variable when launching Plex 

Example :

```
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media -p 32400:32400 --net=host -e PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/media jaymoulin/rpi-plex
```

Updating
---

When Plex Media Server new version is released, you will be able to update your running version with this command:
 
```
docker exec plex apt-get update && docker exec plex apt-get upgrade -y
```

Appendixes
---

### Install RaspberryPi Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/054ba73080c49a0fcdbc6932e27887a31c7abce2/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

### Build Docker Image

To build this image locally 
```
docker build -t jaymoulin/rpi-plex .
```


