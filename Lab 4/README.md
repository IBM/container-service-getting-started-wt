# Highly Available Deployments with IBM Cloud Container Service

The goal of this lab is to begin to understand how to deploy a highly available application. It's easier than many think, but can be expensive if deploying across multiple AZs. The example in this lab shows how to deploy an application across two worker nodes in the same AZ (a basic level of high availability, to explore the concepts).

# Federated Kubernetes Cluster: Two Worker Nodes Running the Same Application

To get started, create a paid cluster with two workers and wait for it to provision.

`bx cs cluster-create --name Cluster02 --machine-type b1c.4x16 --location dal10 --workers 2 --public-vlan 1900401 --private-vlan 1900403 --location dal10`

While waiting, you need to download kubefed, which will allow you to set up a kubernetes federated cluster.
As this is for lab purposes only, we will be using an IBM liberty image as a basic template for an imaged application.

Download the kubefed tarfile using curl:

`curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/kubernetes-client-darwin-amd64.tar.gz`

then, unpack the tarfile:

`tar -xzvf kubernetes-client-darwin-amd64.tar.gz`

Copy the extracted binaries to one of the directories in your `$PATH` and set the executable permission on those binaries.

`sudo cp kubernetes/client/bin/kubefed /usr/local/bin`
`sudo chmod +x /usr/local/bin/kubefed`
`sudo cp kubernetes/client/bin/kubectl /usr/local/bin`
`sudo chmod +x /usr/local/bin/kubectl`

# Choosing a host cluster

You’ll need to choose one of your Kubernetes worker node clusters to be the host cluster. The host cluster hosts the components that make up your federation control plane. Ensure that you have a kubeconfig entry in your local kubeconfig that corresponds to the host cluster. You can verify that you have the required kubeconfig entry by running:

`kubectl config get-contexts`

The output should contain an entry corresponding to your host cluster, similar to the following:

```
CURRENT   NAME                                          CLUSTER                                       AUTHINFO                                      NAMESPACE
*         gke_myproject_asia-east1-b_gce-asia-east1     gke_myproject_asia-east1-b_gce-asia-east1     gke_myproject_asia-east1-b_gce-asia-east1

```

You’ll need to provide the kubeconfig context (called name in the entry above) for your host cluster when you deploy your federation control plane.

At this time, export the kubeconfig file for the admin user of the cluster using `bx cs cluster-config <nameOfCluster> --admin`, make a note of it for error handling later.

# Deploy a Federation Control Plane

To deploy a federation control plane on your host cluster, run `kubefed init` command. When you use `kubefed init`, you must provide the following:

```
Federation name
--host-cluster-context, the kubeconfig context for the host cluster
--dns-provider, one of 'google-clouddns', aws-route53 or coredns
--dns-zone-name, a domain name suffix for your federated services
```

The following example command deploys a federation control plane with the name fellowship, a host cluster context rivendell, and the domain `suffix example.com.`:
```
kubefed init fellowship \
    --host-cluster-context=rivendell \
    --dns-provider="google-clouddns" \
    --dns-zone-name="example.com."
```
The domain suffix specified in `--dns-zone-name` must be an existing domain that you control, and that is programmable by your DNS provider. It must also end with a trailing dot.
Once the federation control plane is initialized, query the namespaces:

`kubectl get namespace --context=fellowship`

If you do not see the default namespace listed (this is due to a bug). Create it yourself with the following command:
`kubectl create namespace default --context=fellowship`


# Error Handling During Federation Setup

If you run into an error when using `kubefed init` like the one below:

```
| => kubefed init fellowship --host-cluster-context=Cluster02 --dns-provider="coredns" --dns-zone-name="example.com."
error: unable to read certificate-authority ca-dal10-Cluster02.pem for Cluster02 due to open ca-dal10-Cluster02.pem: no such file or directory
```

This is due to the symbolic path of the .pem file not being sufficient in the kubeconfig. Get the admin kubeconfig file again using
`bx cs cluster-config <nameOfCluster> --admin`

You should get a message like the one below:

`export KUBECONFIG=/Users/ColemanIBMDevMachine/.bluemix/plugins/container-service/clusters/Cluster02-admin/kube-config-dal10-Cluster02.yml`

Use a text editor to open the file where the KUBECONFIG is located, (the full path next to KUBECONFIG= in the line above)

You should see a file that looks similar to the one below:

``` yml
apiVersion: v1
clusters:
- name: Cluster02
  cluster:
    certificate-authority: ca-dal10-Cluster02.pem # This line needs changing to the full path
    server: https://169.46.7.238:30705
contexts:
- name: Cluster02
  context:
    cluster: Cluster02
    user: admin
    namespace: default
current-context: Cluster02
kind: Config
users:
- name: admin
  user:
    client-certificate: admin.pem # So does this one...
    client-key: admin-key.pem     # and this one...
____________________________________
```
The .pem file is in the same location as the kube-config.yml for the kubeconfig. simply swap the local path of the `certificate-authority` to the absolute path you copied from your kubeconfig line. Do the same for `client-certificate` and `client-key`. An example is shown below:




``` yml
apiVersion: v1
clusters:
- name: Cluster02
  cluster:
    certificate-authority: /Users/ColemanIBMDevMachine/.bluemix/plugins/container-service/clusters/Cluster02-admin/ca-dal10-Cluster02.pem
    server: https://169.46.7.238:30705
contexts:
- name: Cluster02
  context:
    cluster: Cluster02
    user: admin
    namespace: default
current-context: Cluster02
kind: Config
users:
- name: admin
  user:
    client-certificate: /Users/ColemanIBMDevMachine/.bluemix/plugins/container-service/clusters/Cluster02-admin/admin.pem
    client-key: /Users/ColemanIBMDevMachine/.bluemix/plugins/container-service/clusters/Cluster02-admin/admin-key.pem
____________________________________
```
Save the file, and then try the `kubefed init` command again. You should see output similar to the text below:

```
________________________________________________________________________________
| ~/.bluemix/plugins/container-service/clusters/Cluster02 @ colemans-mbp (ColemanIBMDevMachine)
| => kubefed init fellowship --host-cluster-context=Cluster02 --dns-provider="coredns" --dns-zone-name="example.com."
Creating a namespace federation-system for federation system components... done
Creating federation control plane service......
```

# Deploying an Application to a Federated Cluster


The API for Federated Deployment is compatible with the API for traditional Kubernetes Deployment. You can create a Deployment by sending a request to the federation data layer.
You can do that using kubectl by running:
`kubectl --context=federation-cluster create -f mydeployment.yaml`

The `–context=federation-cluster` flag tells kubectl to submit the request to the Federation apiserver instead of sending it to a Kubernetes cluster.

This example will deploy a simple nginx image to your federated cluster. The configuration file is shown below:

```yml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 10 # tells deployment to run 10 pods matching the template
  template: # create pods using pod definition in this template
    metadata:
      # unlike pod-nginx.yaml, the name is not included in the meta data as a unique name is
      # generated from the deployment name
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```
save it as deployment.yaml locally.

Once you have saved the nginx configuration file, deploy it to your federated cluster:

`kubectl --context=federeation-cluster -f path/to/deployment.yaml`


If it works, congrats! You have successfully deployed a basic application across two worker nodes using federation.
