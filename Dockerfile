FROM jaymoulin/rpi-python:alpine as builder

ARG PMS_URL='https://downloads.plex.tv/plex-media-server/1.7.5.4035-313f93718/PlexMediaServer-1.7.5.4035-313f93718-arm7.spk'

RUN apk add --update --no-cache curl --virtual .build-deps && \
    curl --progress-bar ${PMS_URL} -o /root/synology.tgz && \
    curl https://raw.githubusercontent.com/uglymagoo/plexmediaserver-installer/master/usr/sbin/start_pms -o /usr/sbin/start_pms && \
    chmod +x /usr/sbin/start_pms && \
    mkdir /usr/lib/plexmediaserver/; \
    tar -xOf /root/synology.tgz package.tgz | tar -xzf - -C /usr/lib/plexmediaserver/; \
    rm -r /usr/lib/plexmediaserver/dsm_config && \
    rm /root/synology.tgz && \
    apk del curl --purge .build-deps

FROM ctarwater/armhf-alpine-rpi-glibc

EXPOSE 32400

VOLUME /root/Library
VOLUME /media

COPY --from=builder /usr/sbin/start_pms /usr/sbin/start_pms
COPY --from=builder /usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/
ADD daemon.sh /root/daemon.sh
RUN chmod +x /root/daemon.sh

CMD ["/root/daemon.sh"]
