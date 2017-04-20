#!/bin/bash

docker build --build-arg PMS_URL=https://downloads.plex.tv/plex-media-server/1.5.5.3634-995f1dead/PlexMediaServer-1.5.5.3634-995f1dead-arm7.spk -t jaymoulin/rpi-plex . --no-cache
