FROM ubuntu:18.04

MAINTAINER "Ribaldo"

# install wget for downloading ambari list and pip for psutil (ambari-metrics-monitor)
RUN apt-get update \
	&& apt-get install -y wget \
	&& apt-get install -y python-pip

# download ambari repo
RUN wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu16/2.x/updates/2.7.3.0/ambari.list \
	&& apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD \
	&& apt-get update

# install ambari-server
RUN apt-get install -y ambari-server

# setup ambari-server
# NOTE: sequence of default options with silent mode: n, 1, y, n
RUN ambari-server setup --silent \
	&& systemctl enable ambari-server

# correct ambari-monitor installation
# RUN export PYTHON=/usr/bin/python2.7 \
	# && pip install psutil \
	# && cd /usr/lib/python2.6/site-packages/resource_monitoring/psutil \
	# && make install ambari-metrics-monitor restart

# start ambari metrics
# ambari-metrics
# sudo ambari-metrics-collector start
EXPOSE 8080

CMD ambari-server start \
	&& tail -f /var/log/ambari-server/ambari-server.log
