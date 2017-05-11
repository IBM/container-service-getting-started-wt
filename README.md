
<img src="https://ace-docs-production-red.ng.bluemix.net/docs/api/content/homepage/images/containerServiceIcon.svg" width="200"> <img src="https://kubernetes.io/images/favicon.png" width="200">
# IBM Containers Service Demonstration



This tutorial and demonstration is meant to showcase common usecases of the IBM Container Service on Bluemix.

# Initial Setup

Preconditions:  This doc expects a bluemix account.  Running from the cli expects that you will have the clis installed as well, as per https://console.ng.bluemix.net/docs/containers/cs_cli_install.html .

This walkthough is a presentation for using Docker containers on Kubernetes in the IBM Containers Service.


If you haven't already, provision a cluster (this can take a few minutes, so let it start first). To get the list of data centers, use `bx cs datacenters` - then create your cluster with `bx cs cluster-create --name=<name-of-cluster> --datacenter=<datacenter>`

After creation, before using the cluster, make sure it has completed provisioning and is ready for use. Run `bx cs clusters` and make sure that your cluster is in state "deployed".  Then use `bx cs workers yourclustername` and make sure that all workers are in state "deployed" with Status "Deploy Automation Successful".  Make a note of the public ip of the worker!

# Walkthrough Breakdown

There are three stages to the walkthrough.

Stage 1 walks through creating a deploying a simple "hello world" app in Node.JS, then accessing that app.  If there are issues, it will show how to get the logs and fix them so that it works.

Stage 2 builds on that to expand to a more resilient setup which can survive having containers fail and recover.  In addition, it can use the Vulnerability Adviser to check for potential security and move to an update version without downtime during the replacement deploy.

Stage 3 adds integration to a cloudant service, plus integration within the cluster to access the Watson tone analyzer service.
