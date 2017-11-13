# Lab: Replica Sets and Health Checks

prereq: Have a running deployment with a single replica

In this stage of the demo, we introduce how to update the number of replicas a deployment has, and how to rollout an update safely on kubernetes. We also will introduce how to perform a simple health check.

# Replicas

A replica is how kubernetes accomplishes scaling out a deployment. A replica is a copy of a pod which already contains a running service. By having multiple replicas of a pod, you can ensure your deployment has the available resources to handle increasing load on your application.

To begin updating the replica set, run `kubectl edit deployment/<name-of-deployment>`

You should now be in a vi editor window with a configuration yaml file on your screen
This configuration yaml is the configuration of your current deployment, which we can edit to customize the configuration for more fault tolerance.

You should see a configuration similar to the following:
``` yaml
...
spec:
  replicas: 1
  selector:
    matchLabels:
      run: hw-demo
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: hw-demo
...
```

change the replicas number from 1 to 10, so the configuration now reads:

```yaml
...
spec:
  replicas: 10
  selector:
    matchLabels:
      run: hw-demo
  strategy:
  rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: hw-demo
...
```
Save your changes and exit the editor.

You now have 10 replicas of the deployment running in the same pod, providing fault tolerance. Previously, Kubernetes used replication sets to provision and rollout changes. Recent updates to Kubernetes now rollout changes automatically. To see your changes being rolled out, you can run `kubectl rollout status deployment/<name-of-deployment>`

Running `rollout` will display the replicas. You should see output similar to the output below:

```
=> kubectl rollout status deployment/hw-demo
Waiting for rollout to finish: 1 of 10 updated replicas are available...
Waiting for rollout to finish: 2 of 10 updated replicas are available...
Waiting for rollout to finish: 3 of 10 updated replicas are available...
Waiting for rollout to finish: 4 of 10 updated replicas are available...
Waiting for rollout to finish: 5 of 10 updated replicas are available...
Waiting for rollout to finish: 6 of 10 updated replicas are available...
Waiting for rollout to finish: 7 of 10 updated replicas are available...
Waiting for rollout to finish: 8 of 10 updated replicas are available...
Waiting for rollout to finish: 9 of 10 updated replicas are available...
deployment "hw-demo" successfully rolled out
```

Once the rollout has finished, ensure your pods are running by using: `kubectl get pods`
You should see output listing ten replicas of your deployment:

```
=> kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
hw-demo-562211614-1tqm7   1/1       Running   0          1d
hw-demo-562211614-1zqn4   1/1       Running   0          2m
hw-demo-562211614-5htdz   1/1       Running   0          2m
hw-demo-562211614-6h04h   1/1       Running   0          2m
hw-demo-562211614-ds9hb   1/1       Running   0          2m
hw-demo-562211614-nb5qp   1/1       Running   0          2m
hw-demo-562211614-vtfp2   1/1       Running   0          2m
hw-demo-562211614-vz5qw   1/1       Running   0          2m
hw-demo-562211614-zksw3   1/1       Running   0          2m
hw-demo-562211614-zsp0j   1/1       Running   0          2m
```

# Update Deployment Images

Kubernetes allows you to use a rollout to update a deployment with a new docker image.  This allows you to easily update the running image and also allows you to easily undo a rollout if a problem is discovered after deployment.

First, make a change to your code and build a new docker image with a new tag:

`docker build --tag registry.ng.bluemix.net/<namespace>/hw-demo:2 ../Stage1`

Then push the image to the IBM Containers Registry:

`docker push registry.ng.bluemix.net/<namespace>/hw-demo:2`

Using `kubectl`, you can now update your deployment to use the latest image.  There are two ways to do this, you can either again edit the yaml using `kubectl edit deployment/<name-of-deployment>` or you can just specify a new image via a single command. Using a single command is especially useful when writing deployment automation.  To specify the new image, run the following:

`kubectl set image deployment/hw-demo hw-demo=registry.ng.bluemix.net/<namespace>/hw-demo:2`

Note that a deployment could have multiple containers, in which case each container will have its own name.  Multiple containers can be updated at the same time.  For more information see the following: https://kubernetes.io/docs/user-guide/kubectl/kubectl_set_image/

You can now check the status of the rollout by running `kubectl rollout status deployment/<name-of-deployment>` or by running `kubectl get replicasets`:

```
=> kubectl rollout status deployment/hw-demo
Waiting for rollout to finish: 2 out of 10 new replicas have been updated...
Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 1 old replicas are pending termination...
Waiting for rollout to finish: 1 old replicas are pending termination...
Waiting for rollout to finish: 1 old replicas are pending termination...
Waiting for rollout to finish: 9 of 10 updated replicas are available...
Waiting for rollout to finish: 9 of 10 updated replicas are available...
Waiting for rollout to finish: 9 of 10 updated replicas are available...
deployment "hw-demo" successfully rolled out
```

```
=> kubectl get replicasets
NAME                   DESIRED   CURRENT   READY     AGE
hw-demo-1663871401   9         9         9         1h
hw-demo-3254495675   2         2         0         <invalid>
=> kubectl get replicasets
NAME                   DESIRED   CURRENT   READY     AGE
hw-demo-1663871401   7         7         7         1h
hw-demo-3254495675   4         4         2         <invalid>
...
=> kubectl get replicasets
NAME                   DESIRED   CURRENT   READY     AGE
hw-demo-1663871401   0         0         0         1h
hw-demo-3254495675   10        10        10        1m
```

You can now confirm your new code is active by performing a `curl <public-IP>:<nodeport>`.

If you decide to undo your latest rollout, this can be done by calling `kubectl rollout undo deployment/<name-of-deployment>`

```
=> kubectl rollout undo deployment/hw-demo
deployment "hw-demo" rolled back

```

# Health Checks

The kubelet uses liveness probes to know when to restart a Container. For example, liveness probes could catch a deadlock, where an application is running, but unable to make progress. Restarting a Container in such a state can help to make the application more available despite bugs.

The kubelet uses readiness probes to know when a Container is ready to start accepting traffic. A Pod is considered ready when all of its Containers are ready. One use of this signal is to control which Pods are used as backends for Services. When a Pod is not ready, it is removed from Service load balancers.

In this example, we have defined a HTTP liveness probe, to check health of the container every 5 seconds:
```yml
...
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
    httpHeaders:
      - name: x-Custom-Header
        value: Awesome
  initialDelaySeconds: 5
  periodSeconds: 5
...
```

For the first 10-15 seconds the `/healthz` return a `200` response and will fail afterward. kubelet will automaticlly restart the service.  For reference, the following changes were made to the app.js from Stage1 file:

```javascript
....
var delay = 10000 + Math.floor(Math.random() * 5000)
....
app.get('/healthz', function(req, res) {
  if ((Date.now() - startTime) > delay) {
    res.status(500).send({
      error: 'Timeout, Health check error!'
    })
  } else {
    res.send('OK!')
  }
})
....
```

To try the HTTP liveness check, first, cd into the Stage2 directory, then create and push the sigex-demo-health image to the IBM registry:

```
docker build --tag registry.ng.bluemix.net/<namespace>/health-check-demo .
docker push registry.ng.bluemix.net/<namespace>/health-check-demo
```


Replace the correct namespace in the sigex-demo-health.yml file under the image tag:

```yml
spec:
      containers:
        - name: hw-demo-container
          image: "registry.ng.bluemix.net/<namespace>/health-check-demo" # replace here
          imagePullPolicy: Always
          livenessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
```


Once the yml file is updated, create a Pod:

`kubectl create -f healthcheck.yml`

Run `kubectl get pods` and verify that the image was provisioned to the pod correctly.

Get the ip of your cluster by running `bx cs workers <clustername>`, your nodeport will be 30072.

After 10 secconds, view the Pod events to confirm health check failed and pod restarted:

`kubectl describe pod hw-demo-deployment`

And finally, open a web browser and naviagate to `<cluster-ip>:30072/healthz` to see the endpoint operational, and `<cluster-ip>:30072` to see that the application  tries to work despite having failing nodes. 

Thus you have seen the fault tolerance having multiple replicas provides you. Stage 2 of the lab is now complete!
