#!/bin/sh

source lab2.sh

prompt "now we'll build a version 2 of our image and push it"
# build a new image
docker build --tag ${IMAGE_NAME}:v2

# push it
docker push ${IMAGE_NAME}:v2

# `kubectl set image` to change the underlying image
kubectl set image deployment ${DEPLOYMENT_NAME}


