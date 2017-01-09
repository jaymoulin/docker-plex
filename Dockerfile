FROM resin/rpi-raspbian

RUN apt-get update && apt-get install wget apt-transport-https -y --force-yes
RUN wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add - 
RUN echo "deb https://dev2day.de/pms/ jessie main" > /etc/apt/sources.list.d/pms.list
RUN apt-get update && apt-get install -t jessie plexmediaserver -y

EXPOSE 32400

ENV PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR /media

CMD ["/usr/sbin/start_pms"]
