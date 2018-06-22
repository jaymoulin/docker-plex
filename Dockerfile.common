LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
ARG VERSION=1.13.2
LABEL version=${VERSION}

EXPOSE 32400

VOLUME /root/Library
VOLUME /media

COPY --from=builder /usr/sbin/start_pms /usr/sbin/start_pms
COPY --from=builder /usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/
COPY daemon.sh /usr/sbin/daemon-pms
CMD ["daemon-pms"]
