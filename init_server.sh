#!/bin/sh
VERSION_FILE=version.txt

touch $VERSION_FILE
VERSION_INSTALLED=$(head -n 1 $VERSION_FILE)
echo installed bedrock-server-version $VERSION_INSTALLED

echo search bedrock-server-version...
VERSION=`curl -s -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock | grep -oP '([0-9.])*(?=\.zip)' | head -n 1`
echo found bedrock-server-version $VERSION

if [ "$VERSION" = "" ]
then
 echo version not available
elif [ "$VERSION" != "$VERSION_INSTALLED" ]
then
 echo newer version available...
 echo doing update $VERSION_INSTALLED to $VERSION
 
 echo download bedrock-server-$VERSION.zip...
 wget -q --output-document=bedrock-server.zip https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$VERSION.zip
 if [ `wc -c <bedrock-server.zip` -ge 1000 ]
 then
  echo saved in /data/bedrock-server.zip
 
  echo unzip bedrock-server.zip...
  unzip -oq bedrock-server.zip
  echo files unzipped in /data
 
  echo remove bedrock-server.zip...
  rm -f bedrock-server.zip
  echo bedrock-server.zip removed
  
  echo get more rights to executable
  chmod 777 bedrock_server
  
  echo $VERSION > $VERSION_FILE
 else
  echo download bedrock-server-$VERSION.zip failed
 fi
fi

echo start bedrock_server
./bedrock_server
