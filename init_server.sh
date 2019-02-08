#!/bin/bash

echo search bedrock-server-version...
VERSION=`wget -qO- https://minecraft.net/de-de/download/server/bedrock/ | sed -l 1 -n 's/.*-\([0-9.]*\)\.zip.*/\1/p' | head -n 1`
echo found bedrock-server-version $VERSION

echo download bedrock-server-$VERSION.zip...
wget -q --output-document=bedrock-server.zip https://minecraft.azureedge.net/bin-linux/bedrock-server-$VERSION.zip
echo saved in /data/bedrock-server.zip

echo unzip bedrock-server.zip...
unzip -oq bedrock-server.zip
echo files unzipped in /data

echo remove bedrock-server.zip...
rm -f bedrock-server.zip
echo bedrock-server.zip removed

echo start bedrock_server
./bedrock_server
