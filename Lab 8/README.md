# Microservices in an Orchestrated World


In this final lab, you will go beyond simple containers, and understand how to manage Microservices and Service Oriented Architecture beyond Kubernetes tools. This Lab will introduce Istio as a way to manage and dissect container and cluster traffic. It will use nearly everything you have learned in the previous lab, so please complete the previous labs if you have not already.



# Before you Begin: Install Istio

Installation steps
You can use the Istio Helm chart to install, or follow the steps below.

For the pre0.2 release, Istio must be installed in the same Kubernetes namespace as the applications. Instructions below will deploy Istio in the default namespace. They can be modified for deployment in a different namespace.

1.	Go to the Istio release page, to download the installation file corresponding to your OS or run

`curl -L https://git.io/getIstio | sh -`
to download and extract the latest release automatically (on MacOS and Ubuntu).

2.	Extract the installation file, and change directory to the location where the files were extracted. The following instructions are relative to this installation directory. The installation directory contains:
*	yaml installation files for Kubernetes
*	sample apps
* the istioctl client binary, needed to inject Envoy as a sidecar proxy, and useful for creating routing rules and policies.
* the istio.VERSION configuration file.

3.	Add the istioctl client to your PATH if you download the installation file from Istio release. For example, run the following commands on a Linux or MacOS system:
`export PATH=$PWD/bin:$PATH`

4.	Run the following command to determine if your cluster has RBAC (Role-Based Access Control) enabled:
`kubectl api-versions | grep rbac`

*	If the command displays an error, or does not display anything, it means the cluster does not support RBAC, and you can proceed to step 5 below.

* If the command displays ‘beta’ version, or both ‘alpha’ and ‘beta’, please apply `istio-rbac-beta.yaml` configuration as show below:
(Note: If you deploy Istio in another namespace than the default namespace, replace the `namespace: default` line in all ClusterRoleBinding resources with the actual namespace.)
`kubectl apply -f install/kubernetes/istio-rbac-beta.yaml`

If you get an error:
```
Error from server (Forbidden): error when creating "install/kubernetes/istio-rbac-beta.yaml": clusterroles.rbac.authorization.k8s.io "istio-pilot" is forbidden: attempt to grant extra privileges: [{[*] [istio.io] [istioconfigs] [] []} {[*] [istio.io] [istioconfigs.istio.io] [] []} {[*] [extensions] [thirdpartyresources] [] []} {[*] [extensions] [thirdpartyresources.extensions] [] []} {[*] [extensions] [ingresses] [] []} {[*] [] [configmaps] [] []} {[*] [] [endpoints] [] []} {[*] [] [pods] [] []} {[*] [] [services] [] []}] user=&{user@example.org [...]
  ```
You need to add the following: (replace the name with your own)
`kubectl create clusterrolebinding myname-cluster-admin-binding --clusterrole=cluster-admin --user=myname@example.org`

* If the command displays only ‘alpha’ version, please apply istio-rbac-alpha.yaml configuration:
(Note: If you deploy Istio in another namespace than the default namespace, replace the namespace: default line in all ClusterRoleBinding resources with the actual namespace.)
`kubectl apply -f install/kubernetes/istio-rbac-alpha.yaml`

5.	Install Istio’s core components . There are two mutually exclusive options at this stage:

*	Install Istio without enabling Istio Auth feature:
`kubectl apply -f install/kubernetes/istio.yaml`

This command will install Pilot, Mixer, Ingress-Controller, Egress-Controller core components.


* Install Istio and enable Istio Auth feature (This deploys a CA in the namespace and enables mTLS between the services):
`kubectl apply -f install/kubernetes/istio-auth.yaml`
This command will install Pilot, Mixer, Ingress-Controller, and Egress-Controller, and the Istio CA (Certificate Authority).


6.	Optional: Install addons for metric collection and/or request tracing as described in the following sections.
