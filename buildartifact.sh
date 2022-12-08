#!/bin/bash

echo "check master image is present"

checkmasterimage=`docker images | grep atlas-mvn-masterimage`

if [ -z "$checkmasterimage" ]
then
	docker build -t atlas-mvn-masterimage .
else
	echo "Is present"
fi

containerid=`docker run -d atlas-mvn-masterimage`

cd sample-code-java

echo -e "copying files to container for build"

docker cp ./ $containerid:/opt/work/ 

cd ..

docker cp myStore.p12 $containerid:/opt/work/

echo -e "runing build command.."
docker exec $containerid atlas-mvn package -Dmaven.test.skip=true

docker exec $containerid  jarsigner -keystore myStore.p12 SampleCode.jar code_signing -keypass "env:kpwd" -storepass "env:kpwd"

cd ..

echo -e "copying the artifact to local host "
docker cp $containerid:/opt/work/SampleCode.jar .

echo -e "Stoping the container"

docker stop $containerid
echo -e "Removng the container"
docker rm $containerid
