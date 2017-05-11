#!/bin/bash
echo "Install Bluemix CLI"
. ./install_bx.sh
if [ $? -ne 0 ]; then
  echo "Failed to install Bluemix Container Service CLI prerequisites"
  exit 1
fi

echo "Login to Bluemix"
./bx_login.sh
if [ $? -ne 0 ]; then
  echo "Failed to authenticate to Bluemix Container Service"
  exit 1
fi

echo "Testing yml files for generalized namespace"
./test_yml.sh
if [ $? -ne 0 ]; then
  echo "Failed to find <namespace> in deployment YAML files"
  exit 1
fi

echo "Deploy pods for Stage 3..."
./deploy.sh
if [ $? -ne 0 ]; then
  echo "Failed to Deploy pods for stage 3 to Bluemix Container Service"
  exit 1
fi
