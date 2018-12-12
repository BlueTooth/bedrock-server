FROM ubuntu:latest

RUN apt-get update && \
apt-get install -y unzip curl libcurl4 libssl1.0.0 && \
rm -rf /var/lib/apt/lists/* && \
mkdir /data

VOLUME /data
WORKDIR /data

RUN curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.7.0.13.zip --output bedrock-server.zip && \
unzip bedrock-server.zip && \
rm bedrock-server.zip

EXPOSE 19132

ENV LD_LIBRARY_PATH=.
CMD ./bedrock_server
