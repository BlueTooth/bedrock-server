#!/bin/sh
VERSION_FILE=version.txt

touch $VERSION_FILE
VERSION_INSTALLED=$(head -n 1 $VERSION_FILE)
echo installed bedrock-server-version $VERSION_INSTALLED

echo search bedrock-server-version...
VERSION=`wget -qO- https://www.minecraft.net/en-us/download/server/bedrock/ | sed -l 1 -n 's/.*-\([0-9.]*\)\.zip.*/\1/p' | head -n 1`
echo found bedrock-server-version $VERSION

if [ "$VERSION" == "" ]
then
 echo version not available
elif [ "$VERSION" != "$VERSION_INSTALLED" ]
then
 echo newer version available...
 echo doing update $VERSION_INSTALLED to $VERSION
 
 echo download bedrock-server-$VERSION.zip...
 wget -q --output-document=bedrock-server.zip https://minecraft.azureedge.net/bin-linux/bedrock-server-$VERSION.zip
 echo saved in /data/bedrock-server.zip

 echo unzip bedrock-server.zip...
 unzip -oq bedrock-server.zip
 echo files unzipped in /data

 echo remove bedrock-server.zip...
 rm -f bedrock-server.zip
 echo bedrock-server.zip removed
 
 echo $VERSION > $VERSION_FILE
fi

echo start bedrock_server
./bedrock_server
