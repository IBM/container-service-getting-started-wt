#!/bin/sh

source lab2.sh

# build a new image
docker build --tag registry.ng.bluemix.net/mhbauer/hello-world:v2 .
# push it
docker push registry.ng.bluemix.net/mhbauer/hello-world:v2

# `kubectl set image` to change the underlying image
