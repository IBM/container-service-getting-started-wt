
<img src="https://ace-docs-production-red.ng.bluemix.net/docs/api/content/homepage/images/containerServiceIcon.svg" width="200"> <img src="https://kubernetes.io/images/favicon.png" width="200">
# Developer Works Lab: IBM Bluemix Containers Service and Kubernetes



This lab is meant to be used with the IBM DeveloperWorks Course on the IBM Containers Service and Kubernetes. Watch the videos for each Lab stage prior to starting the Lab work.




# Overview and Initial Setup

Preconditions:  This lab expects a bluemix account.  Running from the cli expects that you will have the clis installed as well, as per https://console.ng.bluemix.net/docs/containers/cs_cli_install.html . If you do not yet have a bluemix account or the kubernetes cli, please do lab 0 before starting the course.

This lab is an introduction to  using Docker containers on Kubernetes in the IBM Containers Service. By the end of the course
you will understand the core concepts of Kubernetes, and be able to deploy your own applications on Kubernetes or the IBM Bluemix Containers Service. 

If you haven't already, provision a cluster (this can take a few minutes, so let it start first). To get the list of data centers, use `bx cs datacenters` - then create your cluster with `bx cs cluster-create --name=<name-of-cluster> --datacenter=<datacenter>`

After creation, before using the cluster, make sure it has completed provisioning and is ready for use. Run `bx cs clusters` and make sure that your cluster is in state "deployed".  Then use `bx cs workers yourclustername` and make sure that all workers are in state "deployed" with Status "Deploy Automation Successful".  Make a note of the public ip of the worker!

#  Lab Breakdown

There are four stages to the Lab.

Lab 0: Provides a walkthrough for installing Bluemix command-line tools and the Kubernetes CLI. You may skip this lab if you have the containers-registry plugin, the Bluemix CLI and Kubectl already installed on your machine.

Lab 1: Walks through creating a deploying a simple "hello world" app in Node.JS, then accessing that app.  If there are issues, it will show how to get the logs and fix them so that it works.

Lab 2: Builds on that to expand to a more resilient setup which can survive having containers fail and recover.  In addition, it can use the Vulnerability Adviser to check for potential security and move to an update version without downtime during the replacement deploy. Lab 2 will also walk through basic volume control and services you need to get started with kubernetes and the IBM Bluemix Containers Service

Lab 3: Adds integration to a watson service, and discusses storing credentials of external services to the cluster.
