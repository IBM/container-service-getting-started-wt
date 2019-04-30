# Lab 0: Get the IBM Cloud Kubernetes Service


Before you begin learning, you need to install the required CLIs to create and manage your Kubernetes clusters in IBM Cloud Kubernetes Service and to deploy containerized apps to your cluster.

This lab includes the information for installing the following CLIs and plug-ins:

* IBM Cloud CLI
* IBM Cloud Kubernetes Service plug-in
* IBM Cloud Container Registry plug-in
* Kubernetes CLI
* Optional: Docker

If you already have the CLIs and plug-ins, you can skip this lab and proceed to the next one.

# Install the IBM Cloud command-line interface

1. As a prerequisite for the IBM Cloud Kubernetes Service plug-in, install the [IBM Cloud command-line interface](https://cloud.ibm.com/docs/cli?topic=cloud-cli-ibmcloud-cli). Once installed, you can access IBM Cloud from your command-line with the prefix `ibmcloud`.
2. Log in to the IBM Cloud CLI: `ibmcloud login`. 
3. Enter your IBM Cloud credentials when prompted.

   **Note:** If you have a federated ID, use `ibmcloud login --sso` to log in to the IBM Cloud CLI. Enter your user name, and use the provided URL in your CLI output to retrieve your one-time passcode. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

# Install the IBM Cloud Kubernetes Service plug-in

1. To create Kubernetes clusters and manage worker nodes, install the IBM Cloud Kubernetes Service plug-in:
   ```ibmcloud plugin install container-service -r Bluemix```
   
   **Note:** The prefix for running commands by using the IBM Cloud Kubernetes Service plug-in is `ibmcloud ks`.

2. To verify that the plug-in is installed properly, run the following command:
```ibmcloud plugin list```

   The IBM Cloud Kubernetes Service plug-in is displayed in the results as `container-service`.

# Download the IBM Cloud Container Registry plug-in

1. To manage a private image repository, install the IBM Cloud Container Registry plug-in:
```
ibmcloud plugin install container-registry -r Bluemix
```
   
   Use this plug-in to set up your own namespace in a multi-tenant, highly available, and scalable private image registry that is hosted by IBM, and to store and share Docker images with other users. Docker images are required to deploy containers into a cluster. 
   
   **Note:** The prefix for running registry commands is `ibmcloud cr`.

2. To verify that the plug-in is installed properly, run `ibmcloud plugin list`

   The plug-in is displayed in the results as `container-registry`.

# Download the Kubernetes CLI

To view a local version of the Kubernetes dashboard and to deploy apps into your clusters, you will need to install the Kubernetes CLI that corresponds with your operating system:

* [OS X](https://storage.googleapis.com/kubernetes-release/release/v1.12.7/bin/darwin/amd64/kubectl)
* [Linux](https://storage.googleapis.com/kubernetes-release/release/v1.12.7/bin/linux/amd64/kubectl)
* [Windows](https://storage.googleapis.com/kubernetes-release/release/v1.12.7/bin/windows/amd64/kubectl.exe)

**For Windows users:** Install the Kubernetes CLI in the same directory as the IBM Cloud CLI. This setup saves you some filepath changes when you run commands later.

**For OS X and Linux users:**

1. Move the executable file to the `/usr/local/bin` directory using the command `mv /<path_to_file>/kubectl /usr/local/bin/kubectl` .

2. Make sure that `/usr/local/bin` is listed in your PATH system variable.
```
$echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

3. Convert the binary file to an executable: `chmod +x /usr/local/bin/kubectl`

# Install Docker
To locally build images and push them to your registry namespace, [install Docker](https://www.docker.com/community-edition#/download). The Docker CLI is used to build apps into images. 

**Note:** The prefix for running commands by using the Docker CLI is `docker`.
