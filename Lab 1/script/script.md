
# Pod

In Kubernetes, a group of one or more containers is called a pod. Containers in a pod are deployed together, and are started, stopped, and replicated as a group. The simplest pod definition describes the deployment of a single container. For example, an nginx web server pod might be defined as such:
```
apiVersion: v1
kind: Pod
metadata:
  name: mynginx
  namespace: default
  labels:
    run: nginx
spec:
  containers:
  - name: mynginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

# Labels

In Kubernetes, labels are a system to organize objects into groups. Labels are key-value pairs that are attached to each object. Label selectors can be passed along with a request to the apiserver to retrieve a list of objects which match that label selector.

To add a label to a pod, add a labels section under metadata in the pod definition:
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
...
```
To label a running pod
```
  [root@kubem00 ~]# kubectl label pod mynginx type=webserver
  pod "mynginx" labeled
```
To list pods based on labels
```
  [root@kubem00 ~]# kubectl get pods -l type=webserver
  NAME      READY     STATUS    RESTARTS   AGE
  mynginx   1/1       Running   0          21m

```


# Deployments

A Deployment provides declarative updates for pods and replicas. You only need to describe the desired state in a Deployment object, and it will change the actual state to the desired state. The Deployment object defines the following details:

The elements of a Replication Controller definition
The strategy for transitioning between deployments
To create a deployment for a nginx webserver, edit the nginx-deploy.yaml file as
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  generation: 1
  labels:
    run: nginx
  name: nginx
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      run: nginx
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx:latest
        imagePullPolicy: Always
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      securityContext: {}
      terminationGracePeriodSeconds: 30

```
and create the deployment
```
[root@kubem00 ~]# kubectl create -f nginx-deploy.yaml
deployment "nginx" created
```
The deployment creates the following objects
```
[root@kubem00 ~]# kubectl get all -l run=nginx

NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/nginx   3         3         3            3           4m

NAME                 DESIRED   CURRENT   READY     AGE
rs/nginx-664452237   3         3         3         4m

NAME                       READY     STATUS    RESTARTS   AGE
po/nginx-664452237-h8dh0   1/1       Running   0          4m
po/nginx-664452237-ncsh1   1/1       Running   0          4m
po/nginx-664452237-vts63   1/1       Running   0          4m
```
