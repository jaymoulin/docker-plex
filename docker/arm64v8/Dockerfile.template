#inspired by https://github.com/chrisanthropic/docker-alpine-rpi-glibc
FROM arm64v8/alpine
COPY qemu-aarch64-static /usr/bin/
RUN apk add curl --no-cache --update --virtual .build-deps && \
    curl -Lo glibc-2.26-r1.apk https://raw.githubusercontent.com/athalonis/docker-alpine-rpi-glibc-builder/master/glibc-2.26-r1.apk && \
    curl -Lo glibc-bin-2.26-r1.apk https://raw.githubusercontent.com/athalonis/docker-alpine-rpi-glibc-builder/master/glibc-bin-2.26-r1.apk && \
    curl -Lo glibc-i18n-2.26-r1.apk https://raw.githubusercontent.com/athalonis/docker-alpine-rpi-glibc-builder/master/glibc-i18n-2.26-r1.apk && \
    apk add --allow-untrusted *.apk && \
    rm *.apk && \
    apk del curl --purge .build-deps
