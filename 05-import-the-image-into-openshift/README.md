# Import the image into OpenShift from quay.io 

In this lab you will learn how to launch a container image into a pod on OpenShift and then access it via an endpoint.

First of all, before you can do anything with OpenShift, you need to create a project.  A project is a place in OpenShift where you can work and launch your containers without disturbing other users working in their own projects. 

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

One of the main design points of OpenShift was to make it really easy to bring source code to the platform and get it running quickly. 

To create an application in OpenShift, we can use the "oc new-app" command which will look at what we provide it (the input), e.g. a container image pull spec and then set up all the OpenShift objects needed to run and manage the application. "oc new-app" can also automatically examine source code and get it running on OpenShift.

Take a look at what this command can do:

```
oc new-app -h
```

The command we'll use below will reach out to quay.io, inspect the image meta-data and then decide what to do. In our case it will do the following:
- create a virtual image object (called an image stream).  Image Streams enable OCP to track any changes in an image - even if the image is located an external registry like quay.io - and then trigger processes in OpenShift, e.g. re-build or deploy containers if base images change.
- Create a deployment object (deployment config).  Deployment Configuration objects knows the specification of a pod to be launched and also knows how to manage the pod over the course of its life (e.g. number of pods to run, how to update, rollbacks etc) 
- A service object is created.  The service object acts like an internal load balancer for a set of identicle pods. 

(Note that if you were able to create your own vote app image in your own quay.io account, you can use yours instead).

Now, we will launch the image. 

Run the following command to initialize the application and launch the container image.

Use --dry-run first to check it is working but without executing anything:

```
oc new-app quay.io/sjbylo/flask-vote-app:latest --name vote-app --dry-run 
```

If all looks well, then execute the command: 

```
oc new-app quay.io/sjbylo/flask-vote-app:latest --name vote-app 
```

It can take a while to pull the image for the first time, especially if you are running OCP on your laptop and downloading over a shared Internet connection.   But, if you already have the centos image layers cached in OpenShift, then the download should be a lot faster. 
After pulling the image from quay.io, the deployment config object will automatically launch it into a vote-app pod. 

Check what's happening with the following command.

```
oc get po
```

Eventually, you should see the pod running.

```
NAME               READY     STATUS    RESTARTS   AGE
vote-app-1-xgl7c   1/1       Running   0          7m
```

Once the pod is up ("Running") and ready ("1/1") you can try and access the application in the pod.


But there is one problem.  By default, the IP address of the pod is not reachable from networks outside the OCP cluster. To access the vote-app pod, we need to create a way to connect to it from an outside network.  To do this, we create a route object.  

Create a route object with the following command.

```
oc expose svc vote-app
```

This will create a _route_ object, which will in turn configure the OCP router (using haproxy) to pass incoming http based connections to our pod (or pods) running inside the OCP cluster. 

Fetch the hostname of the route.

```
oc get route vote-app 
```

You should see a route similar to "vote-app-myproject.192.168.99.100.nip.io".

The following command will fetch the route name into a variable:

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE
```

Now try to access the pod through this route.

```
curl vote-app-myproject.192.168.99.100.nip.io
or 
curl $VOTE_APP_ROUTE
```

Again, you should see the HTML output containing "<title>Favourite Linux distribution</title>". 

If you wish, try it out in a browser.  You should see a working voting app.

Set automatic re-deployment if the source image is updated. 

We will also mark the image stream object to be refreshed periodically (--scheduled=true) so that any changes to the image in Quay.io will trigger an application refresh:

```
oc tag quay.io/sjbylo/flask-vote-app:latest vote-app:latest --scheduled=true
```

After any changes are made to the image - e.g. you re-build the image on quay.io - the pod will be re-deployed in OpenShift (after a few minutes). 

**That's the end of the lab.**

---
Optionally, you might like to try ...

See how easy it is to change the application endpoint (route object) to use https instead of http. 
You can change this in the OCP web console, so log in.

Go to your project, then to Applications (left menu), then to Routes, select your route called vote-app, click Actions->Edit and see if you can find the security option and change from http to https?

Failing that, this can also be done on the command line with the following command!

```
oc patch route vote-app -p '{"spec":{"tls":{"termination":"edge"}}}'
```

Test https is working using the default built-in self-signed certificate. 

```
curl -k https://vote-app-myproject.192.168.99.100.nip.io
```

Remember to switch it back to http again by removing the tls configuration in the route object.

```
oc patch route vote-app --type json -p '[{ "op": "remove", "path":"/spec/tls"}]'
```

Http should work again.

```
curl vote-app-myproject.192.168.99.100.nip.io
```

