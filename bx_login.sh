#!/bin/sh

if [ -z $CF_ORG ]; then
  CF_ORG="$BLUEMIX_ORG"
fi
if [ -z $CF_SPACE ]; then
  CF_SPACE="$BLUEMIX_SPACE"
fi


if [ -z "$BLUEMIX_API_KEY" || [ -z "$BLUEMIX_NAMESPACE" ]; then
  echo "Define all required environment variables and rerun the stage."
  exit 1
fi
echo "Deploy pods"

echo "ibmcloud login -a $CF_TARGET_URL"
ibmcloud login -a "$CF_TARGET_URL" -o "$CF_ORG" -s "$CF_SPACE" --apikey "$BLUEMIX_API_KEY"
if [ $? -ne 0 ]; then
  echo "Failed to authenticate to IBM Cloud"
  exit 1
fi

# Init container clusters
echo "ibmcloud ks init"
ibmcloud ks init
if [ $? -ne 0 ]; then
  echo "Failed to initialize to IBM Cloud Container Service"
  exit 1
fi

# Init container registry
echo "ibmcloud cr login"
ibmcloud cr login
if [ $? -ne 0 ]; then
  echo "Failed to login to the IBM Cloud Container Registry"
  exit 1
fi