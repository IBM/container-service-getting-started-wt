# Lab 3: Deploy an application with IBM Watson services

In this lab, we walk through setting up an application to leverage the Watson Tone Analyzer service. If you have yet to create a cluster, please refer to lab 1 of this walkthrough.

# Deploying the Watson app

1. Login to IBM Cloud Container Registry:
`bx cr login`

2. Change the directory to `"Lab 3/watson"`.

3. Build the `watson` image:
`docker build -t registry.ng.bluemix.net/<namespace>/watson .`

4. Push the `watson` image to IBM Cloud Container Registry:
`docker push registry.ng.bluemix.net/<namespace>/watson`

Tip: If you run out of registry space, clean up previous
lab's images with this example command: `bx cr image-rm registry.ng.bluemix.net/<namespace>/hello-world:2`

5. Change the directory to `"Lab 3/watson-talk"`.

6. Build the `watson-talk` image:
`docker build -t registry.ng.bluemix.net/<namespace>/watson-talk .`

7. Push the `watson-talk` image to IBM Cloud Container Registry:
`docker push registry.ng.bluemix.net/<namespace>/watson-talk`

8. In `watson-deployment.yml`, update the image tag with the registry path to the image you created in the following two sections:

```yml
    spec:
      containers:
        - name: watson
          image: "registry.ng.bluemix.net/<namespace>/watson" # change to the path of the watson image you just pushed.
                                                          # ex: image: "registry.ng.bluemix.net/<namespace>/watson"
...
    spec:
      containers:
        - name: watson-talk
          image: "registry.ng.bluemix.net/<namespace>/watson-talk" # change to the path of the watson-talk image you just pushed.
                                                               # ex: image: "registry.ng.bluemix.net/<namespace>/watson-talk"
```


# Creating an instance of the IBM Watson service via the CLI

In order to begin using the Watson Tone Analyzer (the IBM Cloud service for this application), we must first request an instance of the Watson service in the org and space we have set up our cluster in.

1. If you need to check what space and org you are currently using, simply run `bx login`. Then use `bx target --cf` to select the space and org you were using for labs 1 and 2.

2. Once we have set our space and org, run `bx cf create-service tone_analyzer standard tone`, where `tone` is the name we will use for the Watson Tone Analyzer service.

Note: When you add the Tone Analyzer service to your account, a message is displayed that the service is not free. If you [limit your API calls](https://www.ibm.com/watson/developercloud/tone-analyzer.html#pricing-block), this tutorial does not incur charges from the Watson service.

3. Run `bx cf services` to ensure a service named `tone` was created.

# Binding the Watson service to your cluster

1. Run `bx cs cluster-service-bind <name-of-cluster> default tone` to bind the service to your cluster. This command will create a secret for the service.

2. Verify the secret was created by running `kubectl get secrets`.

# Creating pods and services

Now that the service is bound to the cluster, we want to expose the secret to our pod so it can utilize the service. You can do this by creating a secret datastore as a part of your deployment configuration. This has been done for you in watson-deployment.yml:

```yml
    volumeMounts:
            - mountPath: /opt/service-bind
              name: service-bind-volume
      volumes:
        - name: service-bind-volume
          secret:
            defaultMode: 420
            secretName: binding-tone # from the kubectl get secrets command above
```

1. Build the application using the yaml:
  - `cd "Lab 3"`
  - `kubectl create -f watson-deployment.yml`

2. Verify the pod has been created:

`kubectl get pods`

At this time, your secret was created. Note that for this lab, this has been done for you.

# Putting It All Together - Run the Application and Service

By this time you have created pods, services and volumes for this lab.

1. You can open the Kubernetes dashboard and explore all new objects created or use the following commands:
  ```
  kubectl get pods
  kubectl get deployments
  kubectl get services
  ```

2. Get the public IP for the worker node to access the application:

`bx cs workers <name-of-cluster>`

3. Now that the you got the container IP and port, go to your favorite web browser and launch the following URL to analyze the text and see output: `http://<public-IP>:30080/analyze/"Today is a beautiful day"`

If you can see JSON output on your screen, congratulations! You are done with lab 3!
