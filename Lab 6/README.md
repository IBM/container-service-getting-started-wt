# CI/DC with the IBM Bluemix Containers Service


This section is under construction. An outline of what is to come is show below.

# Outline
Goal: Understand the CI/DC offerings available to developers to create a highly secure deployment in the IBM Containers Service


1. Introduction

  * Explain CI/DC as it applies to kubernetes components (deployment, pod, and container image level)
  https://console.bluemix.net/docs/containers/cs_security.html#cs_security


2. Body

  * Discuss common CI/DC pipelines
  * Instana monitoring and visualization for DevOps Enablement
  * IBM Managed DevOps Service Pipeline w/ IBM Containers Service

3. Conclusion
  * Review CI/DC topics above (restated reinforcement)
  * five question quiz



# Introduction




# Instana

  Instana APM and BlueMix Container Service

  Instana is a Dynamic Application Performance Management solution specifically designed for monitoring the service quality and performance of constantly changing microservice based applications. This lab will detail the journey of initial deployment of the Instana solution into an application running on the Bluemix Container Service, then illustrate the subsequent visibility of live service performance delivered to the DevOps teams managing the application.

  Setting up a Kubernetes cluster in Bluemix

  The first step is to create a Bluemix account. After you’ve successfully logged into Bluemix,

  `bx cs cluster-create --name --location --workers 2 --machine-type u1c.2x4 --hardware shared --public-vlan --private-vlan`

# Deploying Instana Application Monitoring Agents via IBM Bluemix Container Service

  Now that the environment is provisioned, you have a blank canvas into which you can deploy your containerized application.

  The next step is to deploy the Instana agent. Prior to installing the agent, please request a trial of Instana at https://www.instana.com/.

  Your Instana instance will be provisioned, and now you can deploy the Instana agent. Prior to deploying it, login to your Instana customer portal and obtain your agent key. You can reach the Instana portal by visiting `https://(your instance name).instana.io/ump/instana//agentkeys/`



  Copy the agent key (obscured on the above screen shot). For security reasons, the agent key has to be encoded. To do this, simply issue the following command on a Linux or OSX shell:

  `/bin/echo -n "The Key" | base64`
  Now you are ready to prepare your deployment file. The Instana agent runs on a kubernetes cluster as a daemon set.

  Download the instana-agent.yml file and make two edits within the file. Note that the YAML (.yml) files are very syntax sensitive. instana-agent.yml

  After your Instana agent file is ready, all you need to do is run a kubectl deploy command:

  `kubectl -f create instana-agent.yml`

  Within a few seconds, you will see the following response:

```txt
  namespace "instana-agent" created
  secret "instana-agent-secret" created
  daemonset "instana-agent" created
  To make sure the agent deployed correctly, please issue the following command:

  kubectl get all --namespace instana-agent
  You should receive the following response:

  NAME	READY	STATUS	RESTARTS	AGE
  po/instana-agent-893p6	1/1	Running	0	1m
  If the value for “READY” isn’t 1/1, please wait until the agent is fully deployed.
```
  Meanwhile, back in the Instana UI (https://(your instance name)-instana.instana.io), you will notice the first event of host discovery. This is the worker where your containers are running. I am running the free BlueMix trial, so I only have one worker node.



  Shortly you will see a new host (in the shape of a cuboid) appear. In a few seconds, Instana’s automatic discovery will have found all running containers (with no additional configuration).


  And this is what a map of all the running containers looks like:


  At this point, of course, you only see the components of your kubernetes worker nodes. There’s no actual application running in this environment. So let’s start one up.

  Adding a sample application will allow you to see all the things Instana can do with an application deployed onto Bluemix:

  * Automatically discovers details about applications
  * Tracks application performance and scalability
  * Gather metrics at one second resolution
  * Detect errors within 3 seconds of occurrence
  * Capture 100% of service calls
  * Deploying a Sample Application

  For the sake of simplicity, let’s deploy a small sample application which has a Java Wildfly component making read-only calls into a mysql database. This sample application is provided by Arun Gupta from Amazon Web Services.

  After downloading the sample application, you will see the following files:

  mysql-pod.yaml
  mysql-service.yaml
  README.md
  wildfly-rc.yaml
  mysql-pod creates a single container pod to hold an instance of a mysql database
  mysql-service exposes the mysql pod to the wildfly replicate set
  wildfly-rc is a single node replicate set that takes requests from the client and issues SQL calls against mysql
  In order to deploy this sample application, let’s use a simple approach. Keep in mind that kubernetes offers many other options to deploy applications.

  First deploy the mysql pod:

  `kubectl -f mysql-pod.yaml`
  Then deploy the mysql service:

  `kubectl -f mysql-service.yaml`
  Lastly, deploy the wildfly replica set:

  `kubectl -f wildfly-rc.yaml`
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
  Note:  svc/kubernetes is a component of Bluemix.

  Better yet, switch over to your Instana instance and you will notice that now there are two extra containers on the stack, as illustrated in the following image captures.







  Another way to visualize your deployment it to use the Instana Container View. Notice the mysql-pod and the wildfly-rc-(pod number). Because pods on a replica set are automatically created by the controller, the pod is named after the replicate-set concatenated by an individual ID.



# Instana Automatic Application Discovery

  While this is a simple application, the automatic discovery was automatic. And the same principles of automatic discovery apply to very complex applications as well.

  Notice that on the JBoss Wildfly dashboard, we capture services. Services are automatically discovered by Instana and can be used as a proxy for how the end user uses and experiences your application. For more details, please visit Instana’s Service Mapper Documentation.

  Notice also the discovery stack (also called an “Elevator”) on the very top of the JBoss Wildfly dashboard:



  Instana discovered the host, a container running on that host, and a process running inside that container. Furthermore, Instana automatically determined that the process is a JVM and that a JBoss Wildfly application has been deployed. Each one of these discoveries is done thanks to an Instana sensor. Read more about Sensors.

  Select the JVM sensor by clicking on the word “JVM” in the discovery stack / elevator. Set the time window slider to be a minute (lower left-hand corner of the screen) and scroll down the JVM dashboard until you see the “Garbage Collection” tile. Notice the real time metric variation. Case in point: a lot goes on inside of a JVM (and any other application component for that matter) within a second. Imagine what you are missing if you are using a tool that averages metrics every minute.





# Generating Load on our sample application

  For as great as Instana auto-discovery and infrastructure monitoring is, we are just getting started. We now need to generate load on our sample application. You may choose to expose the wildfly replicate set via a service, which is a bit more complicated, but easily achieved. I opted for connecting to the running pod via ssh and generating the traffic on the pod itself.

  To do that, first you will need the pod name.

  `kubectl get pods`

  ```txt
  NAME	READY	STATUS	RESTARTS	AGE
  mysql-pod	1/1	Running	0	20m
  wildfly-rc-b52f5	1/1	Running	0	19m

  ```
  Now issue the following command:

  `kubectl -it exec wildfly-rc-b52f5 /bin/bash`

  When you see this:

  `[jboss@wildfly-rc-b52f5 ~]$`
  you are officially inside the running pod. For the record, accessing a POD or a container via SSH is frowned upon by the purist. But after all, we are just trying to show how to monitor a kubernetes application, not to teach you about kubernetes.

  Now issue the following command:

  `curl localhost:8080/employees/resources/employees`
  This command will return an XML file with all employees on our sample database.
  You may also get to specific employees by issuing:

  `curl localhost:8080/employees/resources/employee/<n>`, where <n> is the employee number.
  If you choose a high number, such as 100, you will notice an error. This is there to simulate an application issue.

  An easy way to generate for constant load is to issue this command:

  ```txt
  for i in `seq 1 20`; do curl localhost:8080/employees/resources/employees;done
  ```
  While this command is running, go to your Instana Application Map to see a full end-to-end map of the employee service and its database dependency. You will also see that Instana captures traces for every request.



  Note: Each dot on the screen represents a service.

  Now select traces from the top menu. You will see something like this:



  Every single service. Click on the JDBC call in the lower right-hand corner (by clicking it), and you will see details of the SQL called issued against the MySQL database.

  If you actually generated some erroneous calls (with a request greater than 100 – i.e., `curl localhost:8080/employees/resources/employee/100 `),
  you will also see traces that are prefixed with a lightning bolt. These are traces where an error has been detected. You may also get to those by using our dynamic filtering capability.

  Focusing in on a Specific Entity

  On the top of the screen is the Instana search bar. In the search bar, type the following filter:



  Notice how Instana autocompletes the search for you using Lucene search syntax.



  Select one of the erroneous traces, and expand the box highlighted in red:



  Instana is showing the exact exception that was captured when the application attempted to retrieve an employee that doesn’t exist.

  This has just scratched the surface of the capabilities and value of Instana. You can try this on your own, or feel free to reach to me personally at pedro.pacheco@instana.com if you have any questions.

# Conclusion of Instana Lab

  IBM Bluemix Container Service makes it easy to set up a Kubernetes cluster to host your containerized applications. When running such applications in production, operational visibility and performance monitoring is required to ensure that applications are running as expected. Instana’s Dynamic APM delivers just such visibility and performance management for dynamic containerized applications running in the cloud.
