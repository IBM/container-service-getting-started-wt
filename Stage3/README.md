# Lab: Attaching Watson Services to a Deployment

In this stage, we walk through setting up an application to leverage the Watson Tone Analyzer service. If you have yet to create a cluster, please refer to stage 1 of this walkthrough.

We will be using the watson folder under the stage3 directory for the duration of the application.

# Lab steps

Run the following to begin this lab:

1. Login to Container Registry
  - `bx cr login`


2. Change current directory to `Stage3/watson`
  - `cd Stage3/watson`


3. Build `watson` image
  - `docker build -t registry.ng.bluemix.net/<namespace>/watson .`

4. Push `watson` image to IBM Container Registry
  - `docker push registry.ng.bluemix.net/<namespace>/watson`


5. Change current directory to `Stage3/watson-talk`
  - `cd Stage3/watson-talk`


6. Build `watson-talk` image
  - `docker build -t registry.ng.bluemix.net/<namespace>/watson-talk .`


7. Push `watson` image to IBM Container Registry

  - `docker push registry.ng.bluemix.net/<namespace>/watson-talk`

In `watson-deployment.yml`, update the image tag with the registry path to the image you created:

```yml
    spec:
      containers:
        - name: watson
          image: "registry.ng.bluemix.net/contbot/watson" # change to the path of the watson image you just pushed.
                                                          # ex: image: "registry.ng.bluemix.net/<namespace>/watson"
...
    spec:
      containers:
        - name: watson
          image: "registry.ng.bluemix.net/contbot/watson-talk" # change to the path of the watson-talk image you just pushed.
                                                               # ex: image: "registry.ng.bluemix.net/<namespace>/watson-talk"
```


# Create a bluemix service via the cli

In order to begin using the watson tone analyzer (the bluemix service this application), we must first request an instance of the analyzer in the org and space we have set up our cluster in. If you need to check what space and org you are currently using, simply run `bx login` and select the space and org you were using for stage 1 and 2 of the lab.

Once we know our space and org, run `cf create-service tone_analyzer standard tone`, where `tone` is the name we will use for the watson tone analyzer service

Run `cf services` to ensure a service named tone was created. You should see output like the following:

```
Invoking 'cf services'...

Getting services in org cjackso / space myspace as cjackso@us.ibm.com...
OK

name   service         plan       bound apps   last operation
tone    tone_analyzer   standard                create succeeded

```

# Bind a Service to a Cluster

Run `bx cs cluster-service-bind <name-of-cluster> default <name-of-service>` to bind the service to your cluster. This command will create a secret for the service.

Verify the secret was created by running `kubectl get secrets`

# Create pods and services

Now that the service is bound to the cluster, we want to expose the secret to our pod so it can utilize the service. You can do this by creating a secret datastore as a part of your deployment configuration. This has been done for you in watson-deployment.yml:

```yml
    volumeMounts:
            - mountPath: /opt/service-bind
              name: service-bind-volume
      volumes:
        - name: service-bind-volume
          secret:
            defaultMode: 420
            secretName: 2a5baa4b-a52d-4911-9019-69ac01afbb7f-key0 # from the kubectl get secrets command above
```

Once the YAML configuration is updated, build the application using the yaml:
  - `cd Stage3`
  - `kubectl create -f watson-deployment.yml`

Verify the pod has been created:
  'kubectl get pods'

At this time, verify the secret was created and grab the json secret file to configure your application. Note that for this demo, this has been done for you:
`kubectl exec <pod_name> -it /bin/bash`

`cd /opt/service-bind`

`ls`

If the volume containing the secrets has been mounted, a file named binding should be in your CLI output. Cat the file and use it to configure your application to use the service.
'cat binding'

# Putting It All Together - Run the Application and Service

By this time you have created pods, services and volumes for this lab. You can open the dashboard and explore all new objects created or use the following commands:
  ```
  kubectl get pods
  kubectl get deployments
  kubectl get services
  ```

You have to find the Public IP for the worker node to access the application. Run the following command and take note of the same:

`bx cs workers <name-of-cluster>`

Now that the you got the container IP and port, go to your favorite web browswer and launch the following URL to analyze the text and see output: `http://<public-IP>:30080/analyze/<YourTextHere>`

If you can see JSON output on your screen, congratulations! You are done!
