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

To launch an image in OpenShift, first of all we need to tell OpenShift about the image.  Use the following command to "import" the image meta-data. (Note that if you were able to create your own vote app image in your own quay.io account, you can use yours instead).

```
oc import-image vote-app --from quay.io/sjbylo/flask-vote-app:latest --scheduled true --confirm
```

This command will reach out to quay.io, fetch the image _meta-data_ and store it inside a "virtual image" object (called an Image Stream) inside of OpenShift.  Once the image meta-data has been saved in OpenShift, it can be used to pull and launch the image itself.

Check that the image was created properly.

```
oc get is
```

This should show your image called _vote-app_.

Now, we will launch the image. 

Run the following command to launch the container image.

```
# FIXME oc run vote-app --image quay.io/sjbylo/flask-vote-app:latest 
oc new-app quay.io/sjbylo/flask-vote-app:latest --name vote-app 
```

This command will create several objects within your project.  

- A virtual image object (called an image stream).  This stores the meta-data of the image from quay.io.
- A deployment object (called a deployment config).  This holds a specification of the pod to be launched and then launches the pod.
- A service object.  This provides a static IP and hostname and load balances over multiple pods by tracking all the IP addresses of all running vote-app pods. 

It can take a while to pull the image for the first time.
After pulling the image from quay.io, the deployment config object will launch the vote-app pod. 

Check what's happening with the following command.

```
watch oc get po
```

Eventually, you should see the pod running.

```
oc get po
NAME               READY     STATUS    RESTARTS   AGE
vote-app-1-xgl7c   1/1       Running   0          7m
```



Use Ctr-C to quit from the above _watch_ command.


