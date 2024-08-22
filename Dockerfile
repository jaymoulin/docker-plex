FROM python:alpine as builder
ARG PMS_URL=
ARG TARGETARCH

RUN apk add --update --no-cache curl --virtual .build-deps && \
    if [[ -z "$PMS_URL" ]]; then \
        if [ "$TARGETARCH" == "amd64" ]; then \
            DL_INDEX=1; \
        elif [ "$TARGETARCH" == "arm" ]; then \
            DL_INDEX=3; \
        else \
            DL_INDEX=2; \
        fi; \
        DL_URL=`curl -s 'https://plex.tv/pms/downloads/5.json' | python3 -c "import sys, json; print(json.load(sys.stdin)['nas']['Synology (DSM 7)']['releases'][${DL_INDEX}]['url'])"`; \
    else \
        DL_URL="$PMS_URL"; \
    fi; \
    echo "Will download ${DL_URL}"; \
    echo "ARCH: $TARGETARCH"; \
    curl --progress-bar ${DL_URL} -o /root/synology.tgz && \
    curl https://raw.githubusercontent.com/uglymagoo/plexmediaserver-installer/master/usr/sbin/start_pms -o /usr/sbin/start_pms && \
    chmod +x /usr/sbin/start_pms && \
    curl https://raw.githubusercontent.com/ChuckPa/PlexDBRepair/master/DBRepair.sh -o /usr/sbin/DBRepair && \
    chmod +x /usr/sbin/DBRepair && \
    mkdir /usr/lib/plexmediaserver/; \
    tar -xOf /root/synology.tgz package.tgz | tar -xzf - -C /usr/lib/plexmediaserver/; \
    rm /root/synology.tgz && \
    apk del curl --purge .build-deps

FROM alpine as plexbase-amd64

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.35-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache --force-overwrite \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache --update libstdc++


FROM woahbase/alpine-glibc:armhf as plexbase-arm

ENTRYPOINT ["/bin/sh"]

#inspired by https://github.com/chrisanthropic/docker-alpine-rpi-glibc
FROM arm64v8/alpine as plexbase-arm64
RUN apk add curl --no-cache --update --virtual .build-deps && \
    curl -Lo glibc-2.32-r0.apk https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/glibc-2.32-r0.apk && \
    curl -Lo glibc-bin-2.32-r0.apk https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/glibc-bin-2.32-r0.apk && \
    curl -Lo glibc-i18n-2.32-r0.apk https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/glibc-i18n-2.32-r0.apk && \
    apk add --allow-untrusted --force-overwrite *.apk && \
    rm *.apk && \
    apk del curl --purge .build-deps && \
    ln -s /usr/glibc-compat/lib/ld-linux-aarch64.so.1 /usr/glibc-compat/lib/ld-linux.so.3

FROM plexbase-${TARGETARCH}
LABEL maintainer="Jay MOULIN <https://jaymoulin.me>"
ARG VERSION=1.13.2
ARG TARGETPLATFORM
LABEL version=${VERSION}-${TARGETPLATFORM}

EXPOSE 32400

VOLUME /root/Library
VOLUME /media
#fixes crash on 1.23 (https://forums.plex.tv/t/terminating-with-uncaught-exception-of-type-std-clock-gettime-clock-monotonic-failed/718578/14)

ENV SYSCALL_MAX_ENABLED=1

COPY --from=builder /usr/sbin/start_pms /usr/sbin/start_pms
COPY --from=builder /usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/
COPY --from=builder /usr/sbin/DBRepair /usr/sbin/DBRepair
COPY daemon.sh /usr/sbin/daemon-pms
RUN mkdir -p /config && \
    mkdir -p /root/Library && \
    ln -s /root/Library /config/Library
CMD ["/usr/sbin/daemon-pms"]
