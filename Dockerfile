FROM ubuntu:latest

MAINTAINER BlueTooth

RUN apt-get update && \
apt-get install -y unzip wget && \
rm -rf /var/lib/apt/lists/* && \
mkdir /data

VOLUME /data
WORKDIR /data
ENV LD_LIBRARY_PATH=.

EXPOSE 19132/udp

ENTRYPOINT VER=`wget -qO- https://minecraft.net/de-de/download/server/bedrock/ | sed -l 1 -n 's/.*-\([1-9.]*\)\.zip.*/\1/p' | head -n 1` && \
wget --output-document=/tmp/bedrock-server.zip https://minecraft.azureedge.net/bin-linux/bedrock-server-$VER.zip && \
unzip /tmp/bedrock-server.zip -d /tmp/bedrock-server/ && \
cp -rfv /tmp/bedrock-server/* . && \
rm -rfv /tmp/bedrock-server*

CMD ./bedrock_server
