#!/bin/bash

curlArgs=('-s' '-H' "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36")

downloadFile () {
  echo "download from $2..."
  curl "${curlArgs[@]}" -o $1 $2
  if [ `wc -c <$1` -le 1000 ]
  then
    echo "download $2 failed"
  fi
}

unzipTo () {
  echo "unzip to $2..."
  if [ `wc -c <$1` -ge 1000 ]
  then
    unzip -oq $1 -d $2
    echo "files unzipped to $2"
  else
    echo "zip-file to small"
  fi
}

downloadUnzipAndRemove () {
  downloadFile "file.zip" $1
  unzipTo "file.zip" $2
  rm -f "file.zip"
}

VERSION_FILE=version.txt

touch $VERSION_FILE
VERSION_INSTALLED=$(head -n 1 $VERSION_FILE)
echo installed bedrock-server-version $VERSION_INSTALLED

echo search bedrock-server-version...
VERSION=`curl "${curlArgs[@]}" https://www.minecraft.net/en-us/download/server/bedrock | grep -oP '([0-9.])*(?=\.zip)' | head -n 1`
echo found bedrock-server-version $VERSION

if [ "$VERSION" = "" ]
then
  echo version not available
elif [ "$VERSION" != "$VERSION_INSTALLED" ]
then
  echo "newer version available..."
  echo "doing update $VERSION_INSTALLED to $VERSION"

  downloadUnzipAndRemove `curl "${curlArgs[@]}" https://www.minecraft.net/en-us/download/server/bedrock | grep -oP '([a-z.:/-])*linux([a-z0-9./-])*\.zip' | head -n 1` /data
  
  echo "get more rights to executable"
  chmod 777 bedrock_server
  
  echo $VERSION > $VERSION_FILE

  downloadUnzipAndRemove `curl "${curlArgs[@]}" https://minecraftrtx.net/ | grep -oP '([A-Za-z-:/.])*Normals([0-9.v-])*mcpack' | head -n 1` /data/resource_packs/vanilla-RTX-Normals
  downloadUnzipAndRemove `curl "${curlArgs[@]}" https://minecraftrtx.net/ | grep -oP '([0-9A-Za-z-:/.])*mcpack' | head -n 1` /data/resource_packs/vanilla-RTX

  PACK_ID_NORMALS=`cat /data/resource_packs/vanilla-RTX-Normals/manifest.json | grep -Po '(?<=uuid": ")([0-9a-z-])*' | head -n 1`
  VERSION_NORMALS=`cat /data/resource_packs/vanilla-RTX-Normals/manifest.json | grep -Po '(?<=version": \[)([0-9, ])*' | head -n 1`
  PACK_ID_RTX=`cat /data/resource_packs/vanilla-RTX/manifest.json | grep -Po '(?<=uuid": ")([0-9a-z-])*' | head -n 1`
  VERSION_RTX=`cat /data/resource_packs/vanilla-RTX/manifest.json | grep -Po '(?<=version": \[)([0-9, ])*' | head -n 1`

  echo "add world_resource_packs.json"
  mkdir -p "worlds/Bedrock level"
  cat > "worlds/Bedrock level/world_resource_packs.json" <<EOF
[
  {
    "pack_id": "$PACK_ID_NORMALS",
    "version": [$VERSION_NORMALS]
  },
  {
    "pack_id": "$PACK_ID_RTX",
    "version": [$VERSION_RTX]
  }
]
EOF

  sed -i -e "/server-name=/ s/=.*/=BlueTooth Server/" -e "/texturepack-required=/ s/=.*/=true/"  server.properties
fi

echo start bedrock_server
./bedrock_server
