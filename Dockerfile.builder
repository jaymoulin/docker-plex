FROM python:alpine3.6 as builder
ARG PMS_URL='https://downloads.plex.tv/plex-media-server/1.12.1.4885-1046ba85f/PlexMediaServer-1.12.1.4885-1046ba85f-arm7.spk'
ARG LATEST=1
ARG ARM=1

RUN apk add --update --no-cache curl --virtual .build-deps && \
    if [ "$LATEST" -eq 1 ] && [ "$ARM" -eq 1 ]; then DL_URL=`curl -s 'https://plex.tv/api/downloads/1.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology']['releases'][1]['url'])"`; elif [ "$LATEST" -eq 1 ]; then DL_URL=`curl -s 'https://plex.tv/api/downloads/1.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology']['releases'][2]['url'])"` ; else DL_URL="$PMS_URL"; fi; echo "Will download ${DL_URL}"; \
    curl --progress-bar ${DL_URL} -o /root/synology.tgz && \
    curl https://raw.githubusercontent.com/uglymagoo/plexmediaserver-installer/master/usr/sbin/start_pms -o /usr/sbin/start_pms && \
    chmod +x /usr/sbin/start_pms && \
    mkdir /usr/lib/plexmediaserver/; \
    tar -xOf /root/synology.tgz package.tgz | tar -xzf - -C /usr/lib/plexmediaserver/; \
    rm -r /usr/lib/plexmediaserver/dsm_config && \
    rm /root/synology.tgz && \
    apk del curl --purge .build-deps
