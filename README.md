
<img src="https://ace-docs-production-red.ng.bluemix.net/docs/api/content/homepage/images/containerServiceIcon.svg" width="200"> <img src="https://kubernetes.io/images/favicon.png" width="200">
# IBM Cloud Container Service Lab 

# Introduction

IBM Cloud provides the capability to run applications in containers on Kubernetes. The IBM Cloud Container Service runs Kubernetes clusters which deliver the following: 

* powerful tools
* an intuitive user experience 
* built-in security and isolation to enable rapid delivery of secure applications 
* cloud services including cognitive capabilities from Watson
* the capability to manage dedicated cluster resources for both stateless applications and stateful workloads

Note: This workshop leverages the IBM Cloud Container Service but the core workshop procedure should work on any Kubernetes environment. The exception to this is the initial setup (Lab 0) of the IBM Cloud account and provisioning of a new Kubernetes cluster on the IBM Cloud. 


Preconditions:  This doc expects a IBM Cloud account and all [CLIs installed](https://console.ng.bluemix.net/docs/containers/cs_cli_install.html).

# Overview and Initial Setup

Preconditions:  This lab expects a IBM Cloud account.  Running from the CLI expects that you will have the CLIs installed as well, as per https://console.ng.bluemix.net/docs/containers/cs_cli_install.html. If you do not yet have a IBM Cloud account or the Kubernetes CLI, please do [lab 0](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%200) before starting the course.

This lab is an introduction to  using Docker containers on Kubernetes in the IBM Cloud Container Service. By the end of the course
you will understand the core concepts of Kubernetes and be able to deploy your own applications on Kubernetes in the IBM Cloud Container Service. 

If you haven't already, provision a cluster (this can take a few minutes, so let it start first) with `bx cs cluster-create --name=<name-of-cluster>`

After creation, before using the cluster, make sure it has completed provisioning and is ready for use. Run `bx cs clusters` and make sure that your cluster is in state "deployed".  Then use `bx cs workers yourclustername` and make sure that all worker nodes are in state "deployed" with Status "Deploy Automation Successful".

#  Lab Overview

[Lab 0](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%200) (Optional): Provides a walkthrough for installing IBM Cloud command-line tools and the Kubernetes CLI. You can skip this lab if you have the containers-registry plugin, the IBM Cloud CLI and kubectl already installed on your machine.

[Lab 1](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%201): This lab walks through creating and deploying a simple "hello world" app in Node.JS, then accessing that app. 

[Lab 2](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%202): Builds on lab 1 to expand to a more resilient setup which can survive having containers fail and recover. Lab 2 will also walk through basic services you need to get started with Kubernetes and the IBM Cloud Container Service

[Lab 3](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%203): This lab covers adding external services to a cluster. It walks through adding integration to a Watson service, and discusses storing credentials of external services to the cluster.

[Lab 4](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%204) (Under Construction, Paid Only, Optional): This lab will outline how to create a highly available application, and build on the knowledge you have learned in Labs 1 - 3 to deploy clusters simultaneously to multiple availibility zones. As this requires a paid IBM Cloud account, skip this lab if you are sticking to the free tier.

[Lab 5](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%205): This lab walks through securing your cluster and applications using network policies, and will later add leveraging tools like Vulnerability Advisor to secure images and manage security in your image registry.

[Lab 6](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%206): This lab walks through using Instana for CI/CD monitoring and network patrolling of your cluster.

[Lab 7](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%207): This lab walks through the Kubernetes ecosystem to introduce you to node visualizers like WeaveScope, and package content handling with Helm.

[Lab 8](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%208): This lab walks through microservice architecture at large, and provides a jumping off point to learn Istio.

