#!/bin/sh

source ../lab-scripts/lab.sh

prompt "build the first version of our docker image"
# build image
docker build --tag ${IMAGE_NAME}:v1 .

docker run 

prompt "after building, we push to the container registry, 
        so that our kubernetes cluster can pull it down to run it"

# push it
docker push ${IMAGE_NAME}:v1


