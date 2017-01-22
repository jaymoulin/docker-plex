#!/bin/sh
trap 'kill -TERM $PID' TERM INT
/usr/sbin/start_pms &
PID=$!
wait $PID
wait $PID
rm /root/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid
EXIT_STATUS=$?
