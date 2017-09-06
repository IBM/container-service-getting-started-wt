# Lab 0: Getting the IBM Bluemix Containers Service


Before you begin learning, you will need to install the required CLIs to create and manage your Kubernetes clusters in IBM Bluemix Container Service, and to deploy containerized apps to your cluster.

This lab includes the information for installing these CLIs and plug-ins:


``` txt
Bluemix CLI version 0.5.0 or later
IBM Bluemix Container Service plug-in
Kubernetes CLI version 1.5.6 or later
Optional: Bluemix Container Registry plug-in
Optional: Docker version 1.9. or later
```

If you have the CLIs and plug-ins, you can skip this lab and proceed to the next one.


To install the CLIs:

As a prerequisite for the IBM Bluemix Container Service plug-in, install the bluemix command-line interface, located at https://clis.ng.bluemix.net/ui/home.html. Once installed, you can access bluemix from your command-line with the prefix `bx`.

Log in to the Bluemix CLI with `bx login`. Enter your Bluemix credentials when prompted.



Note: If you have a federated ID, use `bx login --sso` to log in to the Bluemix CLI. Enter your user name and use the provided URL in your CLI output to retrieve your one-time passcode. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

# Install the Containers Service Plugin

To create Kubernetes clusters and manage worker nodes, install the IBM Bluemix Container Service plug-in with `bx plugin install container-service -r Bluemix`. The prefix for running commands by using the IBM Bluemix Container Service plug-in is `bx cs`.

To verify that the plug-in is installed properly, run the following command:
`bx plugin list`

The IBM Bluemix Container Service plug-in is displayed in the results as `container-service`.

Once the bluemix CLI and the containers-service plugin is installed, you can move on to the next phase of the lab.

# Download the Kubernetes CLI.

To view a local version of the Kubernetes dashboard and to deploy apps into your clusters, you will need to install the Kubernetes CLI. The following links will install the CLI. Simply click the link corresponding to your operating system:

OS X: https://storage.googleapis.com/kubernetes-release/release/v1.5.6/bin/darwin/amd64/kubectl
Linux: https://storage.googleapis.com/kubernetes-release/release/v1.5.6/bin/linux/amd64/kubectl
Windows: https://storage.googleapis.com/kubernetes-release/release/v1.5.6/bin/windows/amd64/kubectl.exe

Tip: If you are using Windows, install the Kubernetes CLI in the same directory as the Bluemix CLI. This setup saves you some filepath changes when you run commands later.

For OSX and Linux users, complete the following steps.

Move the executable file to the `/usr/local/bin` directory with `mv /<path_to_file>/kubectl/usr/local/bin/kubectl` .

Make sure that `/usr/local/bin` is listed in your PATH system variable.

```txt
echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```
Convert the binary file to an executable. `chmod +x /usr/local/bin/kubectl`

# Download the Container Registry Plugin

To manage a private image repository, install the Bluemix Container Registry plug-in. Use this plug-in to set up your own namespace in a multi-tenant, highly available, and scalable private image registry that is hosted by IBM, and to store and share Docker images with other users. Docker images are required to deploy containers into a cluster. The prefix for running registry commands is bx cr.


`bx plugin install container-registry -r Bluemix`
To verify that the plug-in is installed properly, run`bx plugin list`
The plug-in is displayed in the results as `container-registry`.

To build images locally and push them to your registry namespace, install Docker If you are using Windows 8 or earlier, you can install the Docker Toolbox External link icon instead. The Docker CLI is used to build apps into images. The prefix for running commands by using the Docker CLI is docker.
