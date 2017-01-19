#!/usr/bin/env bash
trap quit SIGTERM

quit() {
    pkill -f start_pms
    rm /root/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid
    exit 0
}

/usr/sbin/start_pms
quit