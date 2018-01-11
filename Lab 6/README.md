# Continuous Integration and Continuous Delivery with the IBM Cloud Container Service

This section of the lab is designed to get you thinking about Continuous Integration and Continuous Delivery (CI/CD) and monitoring DevOps flows with Containers. By the end of this lab, you will understand the CI/CD offerings available to developers to create a highly secure deployment in IBM Cloud Container Service.

In CI/CD, it is incredibly useful to see a visual representation of the performance and quality of your running clusters. To accomplish this, a performace visualizer is often used, and that's what you're installing today. This lab will detail the journey of initial deployment of the Instana solution into an application running on the IBM Cloud Container Service.

# Instana

Instana is a Dynamic Application Performance Management solution specifically designed for monitoring the service quality and performance of constantly changing microservice based applications.

To get started with this lab, delete the previous deployments and services off of your old cluster, or remove your old cluster entirely. Then, after you’ve successfully logged into IBM Cloud, run:

`bx cs cluster-create --name=Cluster00 --location=dal10 --workers 1 --machine-type u2c.2x4`

  Wait until the cluster sets up with a single worker, then proceed

# Deploying Instana Application Monitoring Agents via IBM Cloud Container Service

  Now that the environment is provisioned, you have a blank canvas into which you can deploy your containerized application.

  The next step is to deploy the Instana agent. Prior to installing the agent, please request a trial of Instana at https://www.instana.com/.

  Your Instana instance will be provisioned, and now you can deploy the Instana agent. Prior to deploying it, login to your Instana customer portal and obtain your agent key. You can reach the Instana portal by visiting `https://(your instance name).instana.io/ump/instana//agentkeys/`

![Image001](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Bluemix-Instana-Agent-Installation-Panel-1024x662.png)

  Copy the agent key (obscured on the above screen shot). For security reasons, the agent key has to be encoded. To do this, simply issue the following command on a Linux or OSX shell:

  `/bin/echo -n "The Key" | base64`

  Now you are ready to prepare your deployment file. The Instana agent runs on a kubernetes cluster as a daemon set.

  Download the instana-agent.yml file, located  here: http://www.instana.com/media/instana-agent.yml_.txt
  and make two edits within the file. Note that the YAML (.yml) files are very syntax sensitive.

  After your Instana agent file is ready, all you need to do is run a kubectl deploy command:

  `kubectl -f create instana-agent.yml`

  Within a few seconds, you will see the following response:

``` txt
  namespace "instana-agent" created
  secret "instana-agent-secret" created
  daemonset "instana-agent" created
```
To make sure the agent deployed correctly, please issue the following command:

  `kubectl get all --namespace instana-agent`
You should receive the following response:


```
  NAME	READY	 STATUS	RESTARTS	AGE
  po/instana-agent-893p6	1/1	Running	0	1m
```
  Meanwhile, back in the Instana UI (https://(your instance name)-instana.instana.io), you will notice the first event of host discovery. This is the worker where your containers are running.

![Image 002](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/IBM-Bluemix-Container-Service-on-an-Instana-Container-Map-1024x542.png)

  Shortly you will see a new host (in the shape of a cuboid) appear. In a few seconds, Instana’s automatic discovery will have found all running containers (with no additional configuration).

  ![Image 003](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-Container-List.png)


  And this is what a map of all the running containers looks like:
  ![Image 004](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-Container-List.png)
  ![Image 005](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-Full-Container-Map-1024x376.png)


  At this point, of course, you only see the components of your kubernetes worker nodes. There’s no actual application running in this environment. So let’s start one up.

  Adding a sample application will allow you to see all the things Instana can do with an application deployed onto IBM Cloud:

  * Automatically discovers details about applications
  * Tracks application performance and scalability
  * Gather metrics at one second resolution
  * Detect errors within 3 seconds of occurrence
  * Capture 100% of service calls
  * Deploying a Sample Application

  For this lab, you will deploy a small sample application which has a Java Wildfly component, making read-only calls into a mysql database. You can get this application from  This sample application is provided by Arun Gupta from Amazon Web Services.

  After downloading the sample application, you will see the following files:
```
  mysql-pod.yaml
  mysql-service.yaml
  README.md
  wildfly-rc.yaml
```
where:
* mysql-pod creates a single container pod to hold an instance of a mysql database
* mysql-service exposes the mysql pod to the wildfly replicate set
* wildfly-rc is a single node replicate set that takes requests from the client and issues SQL calls against mysql
  In order to deploy this sample application, let’s use a simple approach. Keep in mind that kubernetes offers many other options to deploy applications.

  First deploy the mysql pod:

  `kubectl create -f mysql-pod.yaml`
  Then deploy the mysql service:

  `kubectl create -f mysql-service.yaml`
  Lastly, deploy the wildfly replica set:

  `kubectl create -f wildfly-rc.yaml`
  If it all went well, you can issue the following command:

  `kubectl get all`
  And the response should be:


```txt
  NAME	READY	STATUS	RESTARTS	AGE
  po/mysql-pod	1/1	Running	0	1m
  po/wildfly-rc-b52f5	1/1	Running	0	41s

  NAME	DESIRED	CURRENT	READY	AGE
  rc/wildfly-rc	1	1	1	41s

  NAME	CLUSTER-IP	EXTERNAL-IP	PORT(S)	AGE
  svc/kubernetes	10.10.10.1	<none>	443/TCP	40m
  svc/mysql-service	10.10.10.71	<none>	3306:30306/TCP	55s

  ```
  Note:  svc/kubernetes is a component of IBM Cloud.

  Better yet, switch over to your Instana instance and you will notice that now there are two extra containers on the stack, as illustrated in the following image captures.



  ![Image 006](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-Individual-Container-Running-Multiple-Servers.png)
  ![Image 007](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-JBoss-Data-1024x373.png)
  ![Image008](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/MySQL-DB-Container-Dashboard-while-Managing-IBM-Bluemix-Container-Service-1024x370.png)

  Another way to visualize your deployment it to use the Instana Container View. Notice the mysql-pod and the wildfly-rc-(pod number). Because pods on a replica set are automatically created by the controller, the pod is named after the replicate-set concatenated by an individual ID.

  ![Image 009](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Instana-Container-Map-Sorted-by-Kubernetes-Pod-name-1024x390.png)


# Instana Automatic Application Discovery

  While this is a simple application, the automatic discovery was automatic. And the same principles of automatic discovery apply to very complex applications as well.

  Notice that on the JBoss Wildfly dashboard, we capture services. Services are automatically discovered by Instana and can be used as a proxy for how the end user uses and experiences your application. For more details, please visit Instana’s Service Mapper Documentation.

  Notice also the discovery stack (also called an “Elevator”) on the very top of the JBoss Wildfly dashboard:

  ![Image 010](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Instana-Application-Discovery-Stack-in-Bluemix-Container-Service.png)


  Instana discovered the host, a container running on that host, and a process running inside that container. Furthermore, Instana automatically determined that the process is a JVM and that a JBoss Wildfly application has been deployed. Each one of these discoveries is done thanks to an Instana sensor. Read more about Sensors.

  Select the JVM sensor by clicking on the word “JVM” in the discovery stack / elevator. Set the time window slider to be a minute (lower left-hand corner of the screen) and scroll down the JVM dashboard until you see the “Garbage Collection” tile. Notice the real time metric variation. Case in point: a lot goes on inside of a JVM (and any other application component for that matter) within a second. Imagine what you are missing if you are using a tool that averages metrics every minute.

  ![Image 011](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-Instana-Time-Slider.png)
  ![Image 012](https://github.com/colemanjackson/container-service-getting-started-wt/blob/dwworks-additions/Lab%206/Images/Managing-Bluemix-Container-Service-JVM-GC-1024x288.png)



# Conclusion of Instana Lab

  IBM Cloud Container Service makes it easy to set up a Kubernetes cluster to host your containerized applications. When running such applications in production, operational visibility and performance monitoring is required to ensure that applications are running as expected. Instana’s Dynamic APM delivers just such visibility and performance management for dynamic containerized applications running in the cloud. In our next lab, you'll learn other tools like Instana which can be useful for cluster data visualization, not just monitoring.
