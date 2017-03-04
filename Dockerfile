FROM resin/rpi-raspbian

RUN apt-get update && apt-get install wget apt-transport-https -y --force-yes && \
 	wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add - && \
	echo "deb https://dev2day.de/pms/ jessie main" > /etc/apt/sources.list.d/pms.list && \
	apt-get update && apt-get install -t jessie plexmediaserver -y

EXPOSE 32400

VOLUME /root/Library
VOLUME /media

ADD daemon.sh /root/daemon.sh
RUN chmod +x /root/daemon.sh

ENTRYPOINT ["bash"]
CMD ["/root/daemon.sh"]
