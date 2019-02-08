FROM ubuntu:latest

MAINTAINER BlueTooth

COPY ./init_server.sh /
RUN chmod +x /init_server.sh && \
apt-get update && \
apt-get install -y unzip wget curl libcurl4 libssl1.0.0 && \
rm -rf /var/lib/apt/lists/* && \
mkdir /data

VOLUME /data
WORKDIR /data
ENV LD_LIBRARY_PATH=.

EXPOSE 19132/udp

CMD /init_server.sh
