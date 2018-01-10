# Microservices in an Orchestrated World

# Under Construction; please come back later.

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

# Using Istio with Micoservices: BookInfo Lab
This sample deploys a simple application composed of four separate microservices which will be used to demonstrate various features of the Istio service mesh.

# Overview
In this sample we will deploy a simple application that displays information about a book, similar to a single catalog entry of an online book store. Displayed on the page is a description of the book, book details (ISBN, number of pages, and so on), and a few book reviews.

The BookInfo application is broken into four separate microservices:
*	productpage. The productpage microservice calls the details and reviews microservices to populate the page.

* details. The details microservice contains book information.

* reviews. The reviews microservice contains book reviews. It also calls the ratings microservice.

* ratings. The ratings microservice contains book ranking information that accompanies a book review.
There are 3 versions of the reviews microservice:

* Version v1 doesn’t call the ratings service.
* Version v2 calls the ratings service, and displays each rating as 1 to 5 black stars.
* Version v3 calls the ratings service, and displays each rating as 1 to 5 red stars.
The end-to-end architecture of the application is shown below.

 ![Image01]()

This application is polyglot, i.e., the microservices are written in different languages.


To start the application:

1.	Change directory to the root of the Istio installation directory.

2.	Bring up the application containers:
`kubectl apply -f <(istioctl kube-inject -f samples/apps/bookinfo/bookinfo.yaml)`

The above command launches four microservices and creates the gateway ingress resource as illustrated in the diagram below. The reviews microservice has 3 versions: v1, v2, and v3.

Note that in a realistic deployment, new versions of a microservice are deployed over time instead of deploying all versions simultaneously.

Notice that the istioctl kube-inject command is used to modify the bookinfo.yaml file before creating the deployments. This injects Envoy into Kubernetes resources as documented here. Consequently, all of the microservices are now packaged with an Envoy sidecar that manages incoming and outgoing calls for the service.

The updated diagram looks like this:
BookInfo Application

3.	Confirm all services and pods are correctly defined and running:
`kubectl get services`
which produces the following output:

```
NAME                       CLUSTER-IP   EXTERNAL-IP   PORT(S)              AGE
details                    10.0.0.31    <none>        9080/TCP             6m
istio-ingress              10.0.0.122   <pending>     80:31565/TCP         8m
istio-pilot                10.0.0.189   <none>        8080/TCP             8m
istio-mixer                10.0.0.132   <none>        9091/TCP,42422/TCP   8m
kubernetes                 10.0.0.1     <none>        443/TCP              14d
productpage                10.0.0.120   <none>        9080/TCP             6m
ratings                    10.0.0.15    <none>        9080/TCP             6m
reviews                    10.0.0.170   <none>        9080/TCP             6m

```
Now, run  `kubectl get pods`, which produces:

```
NAME                                        READY     STATUS    RESTARTS   AGE
details-v1-1520924117-48z17                 2/2       Running   0          6m
istio-ingress-3181829929-xrrk5              1/1       Running   0          8m
istio-pilot-175173354-d6jm7                 2/2       Running   0          8m
istio-mixer-3883863574-jt09j                2/2       Running   0          8m
productpage-v1-560495357-jk1lz              2/2       Running   0          6m
ratings-v1-734492171-rnr5l                  2/2       Running   0          6m
reviews-v1-874083890-f0qf0                  2/2       Running   0          6m
reviews-v2-1343845940-b34q5                 2/2       Running   0          6m
reviews-v3-1813607990-8ch52                 2/2       Running   0          6m
```

4.	Determine the gateway ingress URL:

`kubectl get ingress -o wide`

```
NAME      HOSTS     ADDRESS                 PORTS     AGE
gateway   *         130.211.10.121          80        1d
```
If your Kubernetes cluster is running in an environment that supports external load balancers, and the Istio ingress service was able to obtain an External IP, the ingress resource ADDRESS will be equal to the ingress service external IP. So, run the following command:
`export GATEWAY_URL=130.211.10.121:80`

If your deployment environment does not support external load balancers (e.g., minikube), the ADDRESS field will be empty. In this case you can use the service NodePort instead:
`export GATEWAY_URL=$(kubectl get po -l istio=ingress -o 'jsonpath={.items[0].status.hostIP}'):$(kubectl get svc istio-ingress -o 'jsonpath={.spec.ports[0].nodePort}')`

5.	Confirm that the BookInfo application is running with the following curl command:
`curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage`
Your response should be 200.

# Configuring Request Routing
This task shows you how to configure dynamic request routing based on weights and HTTP headers.


# Content-based routing
Because the BookInfo sample deploys 3 versions of the reviews microservice, we need to set a default route. Otherwise if you access the application several times, you’ll notice that sometimes the output contains star ratings. This is because without an explicit default version set, Istio will route requests to all available versions of a service in a random fashion.

Note: This task assumes you don’t have any routes set yet. If you’ve already created conflicting route rules for the sample, you’ll need to use replace rather than create in one or both of the following commands.

1.	Set the default version for all microservices to v1.
`istioctl create -f samples/apps/bookinfo/route-rule-all-v1.yaml`
You can display the routes that are defined with the following command:
`istioctl get route-rules -o yaml`

``` yaml
type: route-rule
name: ratings-default
namespace: default
spec:
  destination: ratings.default.svc.cluster.local
  precedence: 1
  route:
  - tags:
      version: v1
    weight: 100
---
type: route-rule
name: reviews-default
namespace: default
spec:
  destination: reviews.default.svc.cluster.local
  precedence: 1
  route:
  - tags:
      version: v1
    weight: 100
---
type: route-rule
name: details-default
namespace: default
spec:
  destination: details.default.svc.cluster.local
  precedence: 1
  route:
  - tags:
      version: v1
    weight: 100
---
type: route-rule
name: productpage-default
namespace: default
spec:
  destination: productpage.default.svc.cluster.local
  precedence: 1
  route:
  - tags:
      version: v1
    weight: 100
---
```
Since rule propagation to the proxies is asynchronous, you should wait a few seconds for the rules to propagate to all pods before attempting to access the application.

2.	Open the BookInfo URL (http://$GATEWAY_URL/productpage) in your browser

You should see the BookInfo application productpage displayed. Notice that the productpage is displayed with no rating stars since reviews:v1 does not access the ratings service.

3.	Route a specific user to reviews:v2

Let’s enable the ratings service for test user “jason” by routing productpage traffic to reviews:v2 instances.

`istioctl create -f samples/apps/bookinfo/route-rule-reviews-test-v2.yaml`

Confirm the rule is created:

`istioctl get route-rule reviews-test-v2`

``` yaml
destination: reviews.default.svc.cluster.local
match:
  httpHeaders:
    cookie:
      regex: ^(.*?;)?(user=jason)(;.*)?$
precedence: 2
route:
- tags:
    version: v2
```

4.	Log in as user “jason” (using the same password) at the productpage web page.

You should now see ratings (1-5 stars) next to each review. Notice that if you log in as any other user, you will continue to see reviews:v1.
Understanding what happened
In this task, you used Istio to send 100% of the traffic to the v1 version of each of the BookInfo services. You then set a rule to selectively send traffic to version v2 of the reviews service based on a header (i.e., a user cookie) in a request.

Once the v2 version has been tested to our satisfaction, we could use Istio to send traffic from all users to v2, optionally in a gradual fashion by using a sequence of rules with weights less than 100 to migrate traffic in steps, for example 10, 20, 30, … 100%.

If you now proceed to the fault injection task, you will see that with simple testing, the v2 version of the reviews service has a bug, which is fixed in v3. So after exploring that task, you can route all user traffic from reviews:v1 to reviews:v3 in two steps as follows:

1.	First, transfer 50% of traffic from reviews:v1 to reviews:v3 with the following command:

`istioctl replace -f samples/apps/bookinfo/route-rule-reviews-50-v3.yaml`

Notice that we are using istioctl replace instead of create.

2.	To see the new version you need to either Log out as test user “jason” or delete the test rules that we created exclusively for him:

* `istioctl delete route-rule reviews-test-v2`
* `istioctl delete route-rule ratings-test-delay`

You should now see red colored star ratings approximately 50% of the time when you refresh the productpage.

Note: With the Envoy sidecar implementation, you may need to refresh the productpage multiple times to see the proper output.

# Final thoughts

Congratulations. You just finished the entire lab on Kubernetes, IBM Cloud Container Service, and the larger microservices ecosystem.
