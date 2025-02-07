#!/bin/bash

curlArgs=('-s' '-H' "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36")

downloadFile () {
  echo "download fron $2..."
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
VERSION=`curl curl "${curlArgs[@]}" https://www.minecraft.net/en-us/download/server/bedrock | grep -oP '([0-9.])*(?=\.zip)' | head -n 1`
echo found bedrock-server-version $VERSION

if [ "$VERSION" = "" ]
then
  echo version not available
elif [ "$VERSION" != "$VERSION_INSTALLED" ]
then
  echo "newer version available..."
  echo "doing update $VERSION_INSTALLED to $VERSION"
  
  downloadUnzipAndRemove "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$VERSION.zip" /data
  
  echo "get more rights to executable"
  chmod 777 bedrock_server
  
  echo $VERSION > $VERSION_FILE

  downloadUnzipAndRemove "https://images.nvidia.com/content/minecraft-with-rtx-beta-resource-packs/nvidia-pbr-example-texturesets-pixelart-feb-2-2021-final.mcpack" /data/resource_packs/nvidia
  downloadUnzipAndRemove "https://minecraftrtx.net/downloads/Vanilla-RTX-v1.21.80.mcpack" /data/resource_packs/vanilla-RTX
  downloadUnzipAndRemove "https://minecraftrtx.net/downloads/Vanilla-RTX-Normals-v1.21.80.mcpack" /data/resource_packs/vanilla-RTX-Normals

  echo "add world_resoure_packs.json"
  cat > "worlds/Bedrock level/world_resoure_packs.json" <<EOF
[
 {
  "pack_id": "a1673412-cb04-4604-8000-04b6396afe80",
  "version": [0, 10, 0]
 },
 {
  "pack_id": "80036ba7-8e6a-4802-8934-22b236601123",
  "version": [1, 21, 80]
 },
 {
  "pack_id": "555ebb78-fa06-4ef7-a5f5-a3a8c3b968bf",
  "version": [1, 21, 80]
 }
]
EOF

fi

echo start bedrock_server
./bedrock_server
