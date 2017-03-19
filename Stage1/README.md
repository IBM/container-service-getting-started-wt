# Stage 1 - Initial Application Deployment

This stage of the tutorial walks through pushing an image of an application to the IBM Containers Registry and deploying a basic application to a cluster


# Pushing an image to the IBM Containers Registry

If you haven't already, provision a cluster (this can take a few minutes, so let it start first). To get the list of data centers, use `bx cs datacenters` - then create your cluster with `bx cs cluster-create --name=<name-of-cluster> --datacenter=<datacenter>`

Download from https://github.com/IBM/container-service-getting-started-wt

cd into IBM-Containers-Demo

Run `bx cr login` and login with your bluemix credentials. This will allow you
to push to the IBM containers registry

Build the example docker image using `docker build --tag registry.ng.bluemix.net/<namespace>/hello-world .`

Verify the image is built using `docker images`

Now push that image up to the IBM registry: `docker push registry.ng.bluemix.net/<namespace>/hello-world`

If you created your cluster at the beginning of this, make sure it's ready for use. Run `bx cs clusters` and make sure that your cluster is in state "deployed".  Then use `bx cs workers <yourclustername>` and make sure that all workers are in state "deployed" with Status "Deploy Automation Successful".  Make a note of the public ip of the worker!

You are now ready to use kubernetes.

# Deploying an App to a Cluster

Run `bx cs cluster-config <yourclustername>` and set the variables based on the output of the command.

Start by running your image as a deployment: `kubectl run hello-world --image=registry.ng.bluemix.net/<namespace>/hello-world`

This will take a bit of time. To check the status of your deployment, you can use `kubectl get pods`

You should see output similar to the following:

```
=> kubectl get pods
NAME                          READY     STATUS              RESTARTS   AGE
hello-world-562211614-0g2kd   0/1       ContainerCreating   0          1m
```
Once the status reads `Running`, expose that deployment as a service, accessed through the ip of the workers.  Our example listens on port 8080.  run `kubectl expose deployment/hello-world --type="NodePort" --port=8080`

To find the port used on that node, now examine your new service: `kubectl describe service <name-of-deployment>`, take note of the "NodePort:" line as `<nodeport>`

Run `bx cs workers <name-of-cluster>` and note the public IP as `<public-IP>`

You can now access your container/service via `curl <public-IP>:<nodeport>` (or your favorite web browser). If you see a "Hello SigEx users! Welcome to containers at IBM!" you're done!!!

When you're all done, you can either use this deployment in the Stage 2 of this demo or you can remove the deployment.  To remove the deployment, use `kubectl delete deployment hello-world`, to remove the service use `kubectl delete service hello-world`
