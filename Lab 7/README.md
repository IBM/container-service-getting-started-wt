# Ecosystem of Kubernetes with the IBM Cloud Container Service

This lab is intended to help you understand the overall ecosystem of plugin offerings available to developers to manage deployments in Kubernetes. This topic is a broad one, but critical for understanding of best practices and data visualization with regards to node layout and overall orchestration strategy. At the end of this lab, a user will understand package management, visualization, and deployment structure of Kubernetes deployments, and the tools used to manage each.

This section is under construction. An outline of what is to come is show below.


# WeaveScope:  Visualizing your Cluster Mappings

Weave Scope provides a visual diagram of your resources within a Kubernetes cluster, including services, pods, containers, processes, nodes, and more. Weave Scope provides interactive metrics for CPU and memory and also provides tools to tail and exec into a container. Complete the following steps to learn how to deploy WeaveScope securely and access it from a web browser locally.

Before you begin:


If you do not have one already, create a standard cluster. Weave Scope can be CPU heavy, especially the app. Run Weave Scope with larger standard clusters, not lite clusters.
Target your CLI to your cluster to run kubectl commands.
To use Weave Scope with a cluster:

Deploy one of the provided RBAC permissions configuration file in the cluster.

To enable read/write permissions:


`kubectl apply -f "https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/weave-scope/weave-scope-rbac.yaml"`
To enable read-only permissions:


`kubectl apply -f "https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/weave-scope/weave-scope-rbac-readonly.yaml"`
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

When you're ready, delete your current cluster and create a new one, and let it provision. Or, clear every service, pod, and deployment from your cluster. When you've decided, continue on to learn about Helm.


# Helm and the IBM Cloud Containers Service: Dependency Management

Helm is an interesting tool to manage Kubernetes charts. Charts are curated Kubernetes applications, designed to work with Helm. I like to think of Kubernetes charts as cooking recipes, however, I need Helm to create my family’s favorite dishes out of these recipes, as Helm allows me to customize the recipes to create exactly what my family wants.
For this, I recommend you to deploy a paid IBM Cloud Container Service cluster. Your kubectl should be configured to work with the cluster. If you don’t, you can follow these steps to deploy your cluster and these steps to setup the bx and kubectl CLI. It is also important to make sure you have permissions to deploy persistent storage as the WordPress chart uses persistent storage by default. Let’s begin the lab:


1. Install Helm: https://github.com/kubernetes/helm/blob/master/docs/install.md
2. Install the WordPress chart:
```
helm install --name my-wordpress-release --set wordpressUsername=admin,wordpressPassword=password,mariadb.mariadbRootPassword=secretpassword,persistence.storageClass=ibmc-file-bronze,mariadb.persistence.storageClass=ibmc-file-bronze stable/wordpress
```
Note the simple parameters we passed into helm install to specify the name of the installation, and the configuration parameters based on the WordPress chart’s values.yaml file. I had to use a specific storage class given IBM Cloud Container Service doesn’t support the alpha storage class (yet).

3. Wait a minute or two to allow everything to reach running. Follow the output from the helm install command to locate the load balancer service IP.
```
# linsun at linsun in ~/workspace/k8s-yamls on git:master ✖︎ [16:30:48]
→ export SERVICE_IP=$(kubectl get svc --namespace default my-wordpress-release-wordpress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```
4. Open your favorite browser and visit `http://$SERVICE_IP/admin or http://$SERVICE_IP/`

That’s it! You should have an working WordPress application running now.

Now let’s look at the set of Kubernetes resources that are deployed as the result of the WordPress chart installation.

```
→ kubectl get deployment,pvc,secrets,svc,pods
NAME                                     DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/my-wordpress-release-mariadb     1         1         1            1           5h
deploy/my-wordpress-release-wordpress   1         1         1            1           5h
NAME                                  STATUS    VOLUME                                     CAPACITY   ACCESSMODES   STORAGECLASS       AGE
pvc/my-wordpress-release-mariadb     Bound     pvc-e869506a-2abd-11e7-90d4-82fbcdd809af   20Gi       RWO           ibmc-file-bronze   5h
pvc/my-wordpress-release-wordpress   Bound     pvc-e8689f1f-2abd-11e7-90d4-82fbcdd809af   20Gi       RWO           ibmc-file-bronze   5h
NAME                                      TYPE                                  DATA      AGE
secrets/my-wordpress-release-mariadb     Opaque                                2         5h
secrets/my-wordpress-release-wordpress   Opaque                                3         5h
NAME                                  CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
svc/my-wordpress-release-mariadb     10.10.10.176   <none>          3306/TCP                     5h
svc/my-wordpress-release-wordpress   10.10.10.171   169.46.90.147   80:30420/TCP,443:32287/TCP   5h
NAME                                                  READY     STATUS    RESTARTS   AGE
po/my-wordpress-release-mariadb-1596346107-fxdrg     1/1       Running   1          5h
po/my-wordpress-release-wordpress-1704943544-0rbzs   1/1       Running   1          5h

```
Obviously, that is a lot of resources, including 2 persistent volume claims. As you can see, with Helm and Helm charts, users can easily deploy interesting applications like WordPress onto Kubernetes with one simple command -helm install, with their preferred ways as long as the configuration parameters are exposed in the values.yaml file. For example, for the WordPress chart, I can choose to enable ingress, change service type, disable persistence, or configure CPU and memory for the pods, etc.


Tools like Helm and charts are fascinating as they enable developers to quickly deploy curated Kubernetes applications and share them with many other users for reuse in each user’s preferred way.
