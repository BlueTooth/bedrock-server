FROM ubuntu:latest

MAINTAINER BlueTooth

RUN apt-get update && \
apt-get install -y unzip curl libcurl4 libssl1.0.0 && \
rm -rf /var/lib/apt/lists/* && \
mkdir /data

VOLUME /data
WORKDIR /data
ENV LD_LIBRARY_PATH=.

EXPOSE 19132

CMD curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.0.24.zip --output bedrock-server.zip && \
unzip -u bedrock-server.zip && \
rm -rf bedrock-server.zip && \
./bedrock_server
