FROM ctarwater/armhf-alpine-rpi-glibc

ARG PMS_URL='https://downloads.plex.tv/plex-media-server/1.5.5.3634-995f1dead/PlexMediaServer-1.5.5.3634-995f1dead-arm7.spk'

RUN apk add curl && \
    curl --progress-bar ${PMS_URL} -o /root/synology.tgz && \
    curl https://raw.githubusercontent.com/uglymagoo/plexmediaserver-installer/master/usr/sbin/start_pms -o /usr/sbin/start_pms && \
    chmod +x /usr/sbin/start_pms && \
    mkdir /usr/lib/plexmediaserver/; \
    tar -xOf /root/synology.tgz package.tgz | tar -xzf - -C /usr/lib/plexmediaserver/; \
    rm -r /usr/lib/plexmediaserver/dsm_config && \
    rm /root/synology.tgz && \
    apk del curl

EXPOSE 32400

VOLUME /root/Library
VOLUME /media

ADD daemon.sh /root/daemon.sh
RUN chmod +x /root/daemon.sh

CMD ["/root/daemon.sh"]
