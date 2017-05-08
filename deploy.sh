#!/bin/bash

echo "Create Demo Application"
IP_ADDR=$(bx cs workers $CLUSTER_NAME | grep normal | awk '{ print $2 }')
if [ -z $IP_ADDR ]; then
  echo "$CLUSTER_NAME not created or workers not ready"
  exit 1
fi

echo -e "Configuring vars"
exp=$(bx cs cluster-config $CLUSTER_NAME | grep export)
if [ $? -ne 0 ]; then
  echo "Cluster $CLUSTER_NAME not created or not ready."
  exit 1
fi
eval "$exp"

echo -e "Setting up Stage 3 Watson Deployment yml"
cd Stage3/
# curl --silent "https://raw.githubusercontent.com/IBM/container-service-getting-started-wt/master/Stage3/watson-deployment.yml" > watson-deployment.yml
#
## WILL NEED FOR LOADBALANCER ###
# #Find the line that has the comment about the load balancer and add the nodeport def after this
# let NU=$(awk '/^  # type: LoadBalancer/{ print NR; exit }' guestbook.yml)+3
# NU=$NU\i
# sed -i "$NU\ \ type: NodePort" guestbook.yml #For OSX: brew install gnu-sed; replace sed references with gsed

echo -e "Deleting previous version of Watson Deployment if it exists"
kubectl delete --ignore-not-found=true -f watson-deployment.yml

echo -e "Unbinding previous version of Watson Tone Analyzer if it exists"
bx cs cluster-service-unbind $CLUSTER_NAME default tone

echo -e "Binding Watson Tone Service to Cluster and Pod"
bx cs cluster-service-bind $CLUSTER_NAME default tone

echo -e "Creating pods"
kubectl create -f watson-deployment.yml

PORT=$(kubectl get services | grep watson-service | sed 's/.*:\([0-9]*\).*/\1/g')

echo ""
echo "View the watson talk service at http://$IP_ADDR:$PORT"
