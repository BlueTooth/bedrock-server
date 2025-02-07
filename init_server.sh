#!/bin/sh
VERSION_FILE=version.txt

touch $VERSION_FILE
VERSION_INSTALLED=$(head -n 1 $VERSION_FILE)
echo installed bedrock-server-version $VERSION_INSTALLED

echo search bedrock-server-version...
VERSION=`curl -s -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" \
 https://www.minecraft.net/en-us/download/server/bedrock | grep -oP '([0-9.])*(?=\.zip)' | head -n 1`
echo found bedrock-server-version $VERSION

if [ "$VERSION" = "" ]
then
 echo version not available
elif [ "$VERSION" != "$VERSION_INSTALLED" ]
then
 echo newer version available...
 echo doing update $VERSION_INSTALLED to $VERSION
 
 echo download bedrock-server-$VERSION.zip...
 curl -s -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" \
  -o bedrock-server.zip \
  https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$VERSION.zip
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
  
  curl -o nvidia.zip https://images.nvidia.com/content/minecraft-with-rtx-beta-resource-packs/nvidia-pbr-example-texturesets-pixelart-feb-2-2021-final.mcpack
  if [ `wc -c <nvidia.zip` -ge 1000 ]
  then
   unzip -oq nvidia.zip -d resource_packs/nvidia
  fi
  
  curl -o vanilla-RTX.zip https://minecraftrtx.net/downloads/Vanilla-RTX-v1.21.80.mcpack
  if [ `wc -c <vanilla-RTX.zip` -ge 1000 ]
  then
   unzip -oq vanilla-RTX.zip -d resource_packs/vanilla-RTX
  fi

  curl -o vanilla-RTX-Normals.zip https://minecraftrtx.net/downloads/Vanilla-RTX-Normals-v1.21.80.mcpack
  if [ `wc -c <vanilla-RTX-Normal.zip` -ge 1000 ]
  then
   unzip -oq vanilla-RTX-Normals.zip -d resource_packs/vanilla-RTX-Normals
  fi
  
  cat > world_resoure_packs.json <<EOF
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

 else
  echo download bedrock-server-$VERSION.zip failed
 fi
fi

echo start bedrock_server
./bedrock_server
