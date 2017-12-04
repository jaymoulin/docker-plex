FROM python:alpine3.6 as builder

ARG PMS_URL='https://downloads.plex.tv/plex-media-server/1.9.7.4460-a39b25852/PlexMediaServer-1.9.7.4460-a39b25852-arm7.spk'
ARG LATEST=1
ARG ARM=1

RUN apk add --update --no-cache curl --virtual .build-deps && \
    if [ "$LATEST" -eq 1 ] && [ "$ARM" -eq 1 ]; then DL_URL=`curl -s 'https://plex.tv/api/downloads/1.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology']['releases'][1]['url'])"`; elif [ "$LATEST" -eq 1 ]; then DL_URL=`curl -s 'https://plex.tv/api/downloads/1.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology']['releases'][2]['url'])"` ; else DL_URL="$PMS_URL"; fi; echo $DL_URL; \
    curl --progress-bar ${DL_URL} -o /root/synology.tgz && \
    curl https://raw.githubusercontent.com/uglymagoo/plexmediaserver-installer/master/usr/sbin/start_pms -o /usr/sbin/start_pms && \
    chmod +x /usr/sbin/start_pms && \
    mkdir /usr/lib/plexmediaserver/; \
    tar -xOf /root/synology.tgz package.tgz | tar -xzf - -C /usr/lib/plexmediaserver/; \
    rm -r /usr/lib/plexmediaserver/dsm_config && \
    rm /root/synology.tgz && \
    apk del curl --purge .build-deps

FROM amd64/alpine

LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"

COPY ./qemu-arm-static /usr/bin/

EXPOSE 32400

VOLUME /root/Library
VOLUME /media

COPY --from=builder /usr/sbin/start_pms /usr/sbin/start_pms
COPY --from=builder /usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/
ADD daemon.sh /root/daemon.sh
CMD ["/root/daemon.sh"]
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && ALPINE_GLIBC_PACKAGE_VERSION="2.26-r0" && ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-\LPINE_GLIBC_PACKAGE_VERSION.apk" && ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-\LPINE_GLIBC_PACKAGE_VERSION.apk" && ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-\LPINE_GLIBC_PACKAGE_VERSION.apk" && apk add --no-cache --virtual=.build-dependencies wget ca-certificates && wget "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" -O "/etc/apk/keys/sgerrand.rsa.pub" && wget "\LPINE_GLIBC_BASE_URL//\LPINE_GLIBC_BASE_PACKAGE_FILENAME" "\LPINE_GLIBC_BASE_URL//\LPINE_GLIBC_BIN_PACKAGE_FILENAME" "\LPINE_GLIBC_BASE_URL//\LPINE_GLIBC_I18N_PACKAGE_FILENAME" && apk add --no-cache "\LPINE_GLIBC_BASE_PACKAGE_FILENAME" "\LPINE_GLIBC_BIN_PACKAGE_FILENAME" "\LPINE_GLIBC_I18N_PACKAGE_FILENAME" && rm "/etc/apk/keys/sgerrand.rsa.pub" && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && apk del glibc-i18n && rm "/root/.wget-hsts" && apk del .build-dependencies && rm "\LPINE_GLIBC_BASE_PACKAGE_FILENAME" "\LPINE_GLIBC_BIN_PACKAGE_FILENAME" "\LPINE_GLIBC_I18N_PACKAGE_FILENAME"  docker build -t jaymoulin/plex:0.3.0-amd64 --build-arg ARM=0 -f .Dockerfile --no-cache=1 .
