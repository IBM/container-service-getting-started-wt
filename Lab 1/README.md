# Lab 1 - Set up and deploy your first application

This lab walks through pushing an image of an application to IBM Cloud Container Registry and deploying a basic application to a cluster.


# Pushing an image to IBM Cloud Container Registry

If you haven't already:
1. Install the CLIs and Docker in [Lab 0](https://github.com/IBM/container-service-getting-started-wt/tree/master/Lab%200).  
2. Provision a cluster: `bx cs cluster-create --name <name-of-cluster>`

To push an image:

1. Download from https://github.com/IBM/container-service-getting-started-wt

2. cd into Lab 1 `cd "Lab 1"`

3. Log in to the IBM Cloud CLI with `bx login`. To specify an IBM Cloud region, include the API endpoint.
Note: If you have a federated ID, use `bx login --sso` to log in to the IBM Cloud CLI. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

4. Run `bx cr login` and login with your IBM Cloud credentials. This will allow you to push images to the IBM Cloud Container Registry.
Tip: This course's commands show the `ng` region. You replace `ng` with the region outputted from the `bx cr login` command.

5. In order to upload our images to the IBM Cloud Container Registry, we first need to create a namespace with the following: `bx cr namespace-add <my_namespace>`

6. Build the example docker image: `docker build --tag registry.ng.bluemix.net/<my_namespace>/hello-world .`

7. Verify the image is built: `docker images`

8. Now push that image up to IBM Cloud Container Registry: `docker push registry.ng.bluemix.net/<namespace>/hello-world`

9. If you created your cluster at the beginning of this, make sure it's ready for use. Run `bx cs clusters` and make sure that your cluster is in state "deployed".  Then use `bx cs workers <yourclustername>` and make sure that all workers are in state "deployed" with Status "Deploy Automation Successful".  Make a note of the public IP of the worker!

You are now ready to use Kubernetes to deploy the hello-world application.

# Deploying your application

1. Run `bx cs cluster-config <yourclustername>` and set the variables based on the output of the command.

2. Start by running your image as a deployment: `kubectl run hello-world --image=registry.ng.bluemix.net/<namespace>/hello-world`
This action will take a bit of time. To check the status of your deployment, you can use `kubectl get pods`
You should see output similar to the following:
```
=> kubectl get pods
NAME                          READY     STATUS              RESTARTS   AGE
hello-world-562211614-0g2kd   0/1       ContainerCreating   0          1m
```
3. Once the status reads `Running`, expose that deployment as a service, accessed through the ip of the workers.  Our example listens on port 8080.  run `kubectl expose deployment/hello-world --type="NodePort" --port=8080`

4. To find the port used on that node, now examine your new service: `kubectl describe service <name-of-deployment>`, take note of the "NodePort:" line as `<nodeport>`

5. Run `bx cs workers <name-of-cluster>` and note the public IP as `<public-IP>`

6. You can now access your container/service via `curl <public-IP>:<nodeport>` (or your favorite web browser). If you see a "Hello world! Your app is up and running in a cluster!" you're done!

When you're all done, you can either use this deployment in the Lab 2 of this demo, or you can remove the deployment and stop taking the course.  To remove the deployment, use `kubectl delete deployment hello-world`, to remove the service use `kubectl delete service hello-world`
