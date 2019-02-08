# Import the image into OpenShift from quay.io 

First of all, before you can do anything with OpenShift, you need to create a project.  A project is a place in OpenShift where you can work and launch your containers without disturbing other users working in their own projects. 

Be sure to choose a cluster unique name for your project!

```
oc new-project <cluster unique project name>
```

You can check which project you are currently in with the following command.

```
oc project
```

You can check which projects you own with the following command.

```
oc projects
```

To initialize an application in OpenShift, we can use the "oc new-app" command which will look at what we provide it (the input), e.g. a container image pull spec and then set up all the objects needed to run and manage the application. 

The below command will reach out to the image in quay.io, inspect the image meta-data and then decide what to do. In our case it will do the following:
- create a virtual image object (called an image stream) which enables OCP to track any changes in the image, even if the image is on an external platform like quay.io.
- Create a deployment object (deployment config) which knows the specification of the pod to be launched and also knows how to manage the pod over the course of it's life (e.g. number of pods to run, updates, rollbacks etc) 
- A service object is created.

(Note that if you were able to create your own vote app image in your own quay.io account, you can use yours instead).

This command will reach out to quay.io, fetch the image _meta-data_ and store it inside a "virtual image" object (called an Image Stream) inside of OpenShift.  Once the image meta-data has been saved in OpenShift, it can be used to pull and launch the image itself.

Now, we will launch the image. 

Run the following command to initialize the application and launch the container image.

```
oc new-app quay.io/sjbylo/flask-vote-app:latest --name vote-app 
```

Check that the pod is being launched.

```
oc get pod
```

We will also mark the image to be refreshed periodically (--scheduled=true) so that any changes to the image in Quay.io will trigger an application refresh. 

```
oc tag quay.io/sjbylo/flask-vote-app:latest vote-app:latest --scheduled=true
```

This command will create several objects within your project.  

- A virtual image object (called an image stream).  This stores the meta-data of the image from quay.io.
- A deployment object (called a deployment config).  This holds a specification of the pod to be launched and then launches the pod.
- A service object.  This provides a static IP and hostname and load balances over multiple pods by tracking all the IP addresses of all running vote-app pods. 

It can take a while to pull the image for the first time.
After pulling the image from quay.io, the deployment config object will launch the vote-app pod. 

Check what's happening with the following command.

```
oc get po
```

Eventually, you should see the pod running.

```
NAME               READY     STATUS    RESTARTS   AGE
vote-app-1-xgl7c   1/1       Running   0          7m
```

Once the pod is up (Running) and ready (1/1) you can try and access the application in the pod.

But there is one problem.  By default, the IP address of the pod is not reachable from networks outside the OCP cluster. To access the vote-app pod, we need to create a way to connect to it from an outside network.  To do this, we create a route object.  

Create a route object with the following command.

```
oc expose svc vote-app
```

This will create a _route_ object, which will in turn configure the OCP router (using haproxy) to pass incomming http based connections to our pod (or pods) running inside the OCP cluster. 

Fetch the hostname of the route.

```
oc get route vote-app 
```

You should see a route similar to "vote-app-myproject.192.168.99.100.nip.io".

Fetch the route name into a variable

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE
```

Now try to access the pod through this route.

```
curl vote-app-myproject.192.168.99.100.nip.io
```
Again, you should see the HTML output containing "<title>Favourite Linux distribution</title>". 

**That's the end of the lab.**

Optionally, you might like to try ...

See how easy it is to change the route object to use https instead of http. 
You can change this in the console, so log in.

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

