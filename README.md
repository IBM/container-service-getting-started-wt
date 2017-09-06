
<img src="https://ace-docs-production-red.ng.bluemix.net/docs/api/content/homepage/images/containerServiceIcon.svg" width="200"> <img src="https://kubernetes.io/images/favicon.png" width="200">
# Developer Works Lab: IBM Bluemix Containers Service and Kubernetes



This lab is meant to be used with the IBM DeveloperWorks Course on the IBM Containers Service and Kubernetes. Watch the videos for each Lab stage prior to starting the Lab work.

# Initial Setup

Preconditions:  This doc expects a bluemix account.  Running from the cli expects that you will have the clis installed as well, as per https://console.ng.bluemix.net/docs/containers/cs_cli_install.html . You can also walk through Lab 0, which covers the

This walkthough is a presentation for using Docker containers on Kubernetes in the IBM Containers Service.


If you haven't already, provision a cluster (this can take a few minutes, so let it start first). To get the list of data centers, use `bx cs datacenters` - then create your cluster with `bx cs cluster-create --name=<name-of-cluster> --datacenter=<datacenter>`

After creation, before using the cluster, make sure it has completed provisioning and is ready for use. Run `bx cs clusters` and make sure that your cluster is in state "deployed".  Then use `bx cs workers yourclustername` and make sure that all workers are in state "deployed" with Status "Deploy Automation Successful".  Make a note of the public ip of the worker!

# lab Breakdown

There are currently three stages to the lab and one optional lab for installation.

Lab 0: Walks through installing the necessary command-line interfaces required to use Kubernetes and the IBM Containers Service. If you already have the clis installed, you may skip this lab.

Lab 1: Walks through creating a deploying a simple "hello world" app in Node.JS, then accessing that app.  If there are issues, it will show how to get the logs and fix them so that it works.

Lab 2: builds on that to expand to a more resilient setup which can survive having containers fail and recover.  In addition, it can use the Vulnerability Adviser to check for potential security and move to an update version without downtime during the replacement deploy.

Lab 3: Shows a user how to integrate an external bluemix service within the cluster and deploy an application leveraging that service. It walks through secret bindings, bluemix services, and advanced deployment.
