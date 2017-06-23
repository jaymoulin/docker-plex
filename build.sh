#!/bin/bash

export PMS_URL=`curl -s 'https://plex.tv/api/downloads/1.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology']['releases'][1]['url'])"`
export PMS_VERSION=`python3 -c "import re; print(re.search('(?<=plex-media-server/)[0-9]+\.[0-9]+\.[0-9]+', '$PMS_URL').group(0))"`
echo "Latest URL : $PMS_URL"
echo "Version : $PMS_VERSION"
DIR="$(cd $( dirname $0) && pwd)"
if [ `docker images "jaymoulin/rpi-plex:$PMS_VERSION" | wc -l` -le 1 ]; then 
    docker build --build-arg "PMS_URL=$PMS_URL" -t "jaymoulin/rpi-plex:$PMS_VERSION" "$DIR" && docker tag "jaymoulin/rpi-plex:$PMS_VERSION" jaymoulin/rpi-plex
else
    echo "Image already built!"
    exit 1
fi
