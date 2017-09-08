
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

There are six stages to the Lab, including an optional advanced lab and a getting started lab.

[Lab 0](https://github.com/colemanjackson/container-service-getting-started-wt/tree/dwworks-additions/Lab%200#lab-0-getting-the-ibm-bluemix-containers-service) (Optional): Provides a walkthrough for installing Bluemix command-line tools and the Kubernetes CLI. You may skip this lab if you have the containers-registry plugin, the Bluemix CLI and Kubectl already installed on your machine.

[Lab 1](https://github.com/colemanjackson/container-service-getting-started-wt/tree/dwworks-additions/Lab%201#lab-1---set-up-and-deploy-your-first-application): This lab walks through creating and deploying a simple "hello world" app in Node.JS, then accessing that app. 

[Lab 2](): Builds on Lab 1 to expand to a more resilient setup which can survive having containers fail and recover. Lab 2 will also walk through basic services you need to get started with kubernetes and the IBM Bluemix Containers Service

[Lab 3](): This lab covers adding external services to a cluster. It walks through adding integration to a watson service, and discusses storing credentials of external services to the cluster.

[Lab 4]() (Under Construction, Paid Only, Optional): This lab will outline how to create a highly available application, and build on the knowledge you have learned in Labs 1 - 3 to deploy clusters simultaneously to multiple availibility zones. As this requires a paid bluemix account, you may skip this lab if you are sticking to the free tier.

[Lab 5]() (Under Construction): This Lab walks through securing your cluster and applications, leveraging tools like Istio and  Vulnerability Advisor to secure images and manage security in your image registry. 
