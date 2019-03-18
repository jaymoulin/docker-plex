FROM python:alpine3.6 as builder
ARG PMS_URL=
ARG ARCH=

RUN apk add --update --no-cache curl --virtual .build-deps && \
    if [[ -z "$PMS_URL" ]]; then \
        if [ "$ARCH" == "amd64" ]; then \
            DL_INDEX=1; \
        elif [ "$ARCH" == "armhf" ]; then \
            DL_INDEX=3; \
        else \
            DL_INDEX=2; \
        fi; \
        DL_URL=`curl -s 'https://plex.tv/pms/downloads/5.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology']['releases'][${DL_INDEX}]['url'])"`; \
    else \
        DL_URL="$PMS_URL"; \
    fi; \
    echo "Will download ${DL_URL}"; \
    curl --progress-bar ${DL_URL} -o /root/synology.tgz && \
    curl https://raw.githubusercontent.com/uglymagoo/plexmediaserver-installer/master/usr/sbin/start_pms -o /usr/sbin/start_pms && \
    chmod +x /usr/sbin/start_pms && \
    mkdir /usr/lib/plexmediaserver/; \
    tar -xOf /root/synology.tgz package.tgz | tar -xzf - -C /usr/lib/plexmediaserver/; \
    rm -r /usr/lib/plexmediaserver/dsm_config && \
    rm /root/synology.tgz && \
    apk del curl --purge .build-deps
