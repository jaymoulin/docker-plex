Raspberry PI - Plex Media Server - Docker Container
=

This container allow you to configure a Plex Media Server easily thanks to Docker.

Installation
---

```
sudo mount /dev/sda1 /mnt/usbdrive #Will mount your USB Drive where your media are
docker run -d --restart=always --name plex -v /mnt/usbdrive:/media -p 32400:32400 --net=host jaymoulin/rpi-plex
```

Configuration
---

Go to http://__raspberry_ip__:32400 to configure it

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


