#!/bin/sh
trap 'kill -TERM $PID' TERM INT SIGTERM SIGINT
rm /root/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid
/usr/sbin/start_pms &
PID=$!
wait $PID
wait $PID
EXIT_STATUS=$?
