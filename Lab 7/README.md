# Ecosystem of Kubernetes with the IBM Bluemix Containers Service

This lab is intended to help you understand the overall ecosystem of plugin offerings available to developers to manage deployments in Kubernetes. This topic is a broad one, but critical for understanding of best practices and data visualization with regards to node layout and overall orchestration strategy. At the end of this lab, a user will understand package management, visualization, and deployment structure of Kubernetes deployments, and the tools used to manage each.

This section is under construction. An outline of what is to come is show below.

# Outline
Goal:


1. Introduction

  * Explain the plugin ecosystem as it applies to kubernetes components


2. Body
  * WeaveScope Demo with IBM Containers Service
  * Istana Demo with the IBM Containers Service -> devops lab
  * Helm Demo with the IBM Containers Service

3. Conclusion
  * Review security topics above (restated reinforcement)
  * five question quiz


#Helm: Get your dependicies in Order

# WeaveScope:  Visualizing your Cluster Mappings

Weave Scope provides a visual diagram of your resources within a Kubernetes cluster, including services, pods, containers, processes, nodes, and more. Weave Scope provides interactive metrics for CPU and memory and also provides tools to tail and exec into a container. Complete the following steps to learn how to deploy WeaveScope securely and access it from a web browser locally.

Before you begin:


If you do not have one already, create a standard cluster. Weave Scope can be CPU heavy, especially the app. Run Weave Scope with larger standard clusters, not lite clusters.
Target your CLI to your cluster to run kubectl commands.
To use Weave Scope with a cluster:

Deploy one of the provided RBAC permissions configuration file in the cluster.

To enable read/write permissions:


`kubectl apply -f "https://raw.githubusercontent.com/IBM-Bluemix/kube-samples/master/weave-scope/weave-scope-rbac.yaml"`
To enable read-only permissions:


`kubectl apply -f "https://raw.githubusercontent.com/IBM-Bluemix/kube-samples/master/weave-scope/weave-scope-rbac-readonly.yaml"`
Output:

```txt
clusterrole "weave-scope-mgr" created
clusterrolebinding "weave-scope-mgr-role-binding" created

```
Now, Deploy the Weave Scope service, which is privately accessible by the cluster IP address:
`kubectl apply --namespace kube-system -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"`
Output:

```txt
serviceaccount "weave-scope" created
deployment "weave-scope-app" created
service "weave-scope-app" created
daemonset "weave-scope-agent" created
```
Run a port forwarding command to bring up the service on your computer. Now that Weave Scope is configured with the cluster, to access Weave Scope next time, you can run this port forwarding command without completing the previous configuration steps again.


`kubectl port-forward -n kube-system "$(kubectl get -n kube-system pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040`
Output:

```txt
Forwarding from 127.0.0.1:4040 -> 4040
Forwarding from [::1]:4040 -> 4040
Handling connection for 4040
```

Finally, open your web browser to http://localhost:4040. Choose to view topology diagrams or tables of the Kubernetes resources in the cluster. If you see a web UI, congratulations, you successfully set up WeaveScope!
