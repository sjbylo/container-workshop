# Import the image into OpenShift from quay.io 

In this lab you will launch a container image into a pod (Kubernetes container) on OpenShift and then access it via a "route" endpoint.

*NOTE: It should be possible to run these labs on Minishift.  Minishift is OpenShift running on your laptop. You can try to use 
Minishift if it is working properly.  However, it is recommended to follow these labs using the
online OpenShift environment if one is provided for you.*

You *cannot* start this lab without access to OpenShift.  Wait for your instructor to show you how to access it before you continue.

After you have the access credentials (host, username and password), access the environment and ensure you are logged into OpenShift. 

# Log in to OpenShift

Use the "whoami" command to determine which user you are using.

```
oc whoami
```
You should see your username.

If you are not logged in to OpenShift, use the following to log in:

```
oc login -u YOUR_USERNAME https://master.openshift.example.com/
<enter your password>
```
(Your instructor will provide you with the OpenShift URL.).


# Create a project

First of all, before you can do anything with OpenShift, you need to create a project.  
A project is a place in OpenShift where you can work and launch your containers without disturbing other 
users working in their own projects. 

Be sure to choose a cluster wide unique name for your project!

```
oc new-project <cluster unique project name>
```

You can check which project you are currently working in with the following command:

```
oc project
```

You can check which projects you have access to with the following command:

```
oc projects
```

One of the main design points of OpenShift was to make it really easy to bring source code to the platform and get it running. 

To create an application in OpenShift, we can use the "oc new-app" command which will look at what we provide it (the input), e.g. 
a container image, and then set up all the OpenShift objects needed to run and manage the application. "oc new-app" 
can also automatically examine source code and get it running on OpenShift.  For now, we will not do that.

Take a look at what this command can do:

```
oc new-app -h
```

The command we'll use below will reach out to quay.io, inspect the image meta-data and then decide what to do. In our case it will do the following:
- create a virtual image object (called an ImageStream).  ImageStreams enable OpenShift to track any changes in an image - 
even if the image is located on an external registry like quay.io - and then trigger processes in 
OpenShift, e.g. re-build or deploy containers if base images change.
- Create a deployment object (DeploymentConfig).  DeploymentConfiguration objects know the specification of a pod to be launched and also knows how to manage the pod over the course of its life (e.g. number of pods to run, how to update, roll back etc) 
- A service object is created.  The service object acts like an internal load balancer for a set of identical pods. 

(Note that if you were able to create your own vote application image in your own quay.io account, you can use yours instead).

---
## Fetch and launch the image from Quay

Run the following command to initialize the application and launch the container image.

Check what we are doing first! Use --dry-run to check what "oc new-app" will do but without executing anything:

```
oc new-app quay.io/YOUR_QUAY_USERNAME/flask-vote-app:latest --name vote-app --dry-run 
```
Remember to replace YOUR_QUAY_USERNAME with your Quay username!
Also, ensure the image, e.g. "flask-vote-app", exists in Quay!

Have a look at the dry run output.  Does it make sense what `oc new-app` will do? 

If all looks well, then execute the command without the dry run: 

```
oc new-app quay.io/YOUR_QUAY_USERNAME/flask-vote-app:latest --name vote-app 
```

It can take a while to pull the image for the first time, especially if you are running OpenShift on your laptop and 
downloading over a shared Internet connection.   But, if you already have the centos image layers cached in OpenShift, 
then the download should be a lot faster. 
After pulling the image from quay.io, the DeploymentConfig object will automatically launch it into a vote-app pod. 

Check the status of the launching pod with this command:

```
oc get po
NAME               READY     STATUS    RESTARTS   AGE
vote-app-1-xgl7c   1/1       Running   0          7m
```

Eventually, you should see the pod running, as shown.


Once the pod is up ("Running") and ready ("1/1") you can try and access the application in the pod.

## Create a route

Now, we want to access the application, but there is one problem.  By default, the IP address of the pod is not reachable from networks outside of the OpenShift cluster. 
To access the vote-app pod, we need to create a way to connect to it from an outside network.  To do this, we create a "route" object.  

Create a route object with the following command:

```
oc expose svc vote-app
```

This will create a _route_ object, which will in turn configure the OpenShift router (using haproxy) to pass incoming http based connections to our pod (or pods) running inside the OpenShift cluster. 

Fetch the hostname of the route:

```
oc get route vote-app 
```

You should see a route similar to "vote-app-myproject.openshift.example.com".

For convenience, the following command will fetch the route name into a variable:

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE
```

Now try to access the pod through this route:

```
curl $VOTE_APP_ROUTE
```

Again, you should see the HTML output containing "`<title>Favourite Linux distribution</title>`". 

Try it out in a browser.  You should see the working voting application.


---
## Set automatic re-deployment if the source image is updated. 

We will also mark the image stream object to be refreshed periodically (--scheduled=true) so that
any changes to the image in Quay.io will trigger an application refresh in OpenShift:

```
oc tag quay.io/YOUR_QUAY_USERNAME/flask-vote-app:latest vote-app:latest --scheduled=true
Tag vote-app:latest set to import quay.io/YOUR_QUAY_USERNAME/flask-vote-app:latest periodically
```

After any changes are made to the image - e.g. you re-build the image on quay.io - the pod will be re-deployed in OpenShift (after a few minutes). 

**That's the end of the lab.**

Workshop contents: https://github.com/sjbylo/container-workshop

---
Optionally, you might like to try ...

You can have your pod automatically re-deployed after a source code change in a couple of ways.  

1. The easiest way would be to make a simple change to the application's code and commit it to your Git Hub repository. 
If the Quay repository has been properly linked to your Git Hub repository (as in the tasks above)
this would trigger a fresh build of the image in Quay which would in turn trigger a re-deployment in OpenShift.
1. Another way, would be to re-build your image on your laptop and then push the changes to Quay.  This would also be detected by OpenShift and the container would be re-deployed.

You can read more about OpenShift and its core concepts here:
https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/index.html 
