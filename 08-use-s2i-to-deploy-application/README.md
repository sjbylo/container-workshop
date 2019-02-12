# Use Source 2 Image to build and launch the application on OpenShift 

In this lab you will enable OpenShift to build our application directly on OpenShift itself. This is done using Source 2 Image (s2i) which does the following:

1 Launches a container from a "builder image" of the matching runtime.  In this case that's python version 2.7 builder image.
1 Executes a build of the application in the running builder container.  After a successful build, commits a new image containing the application. 
1 The image is pushed into the registry which internal to OpenShift. 
1 The container is launched since the DeploymentConfig is configured to launch or re-launch the container if the image is added or updated. 

"oc new-app" is the command that can initialize an application on OCP. 
This command will use the a builder image (python:2.7) and run S2i against the source code, fetched from Github. 

Run the following command to set up S2i for our application.  "oc new-app" is the command that can initialize an application on OCP. 

```
oc new-app python:2.7~https://github.com/sjbylo/flask-vote-app.git --name vote
```

This command will create a build object called a BuildConfiguration (BC).  The BuildConfiguration knows where to fetch the builder image and the source code from. The BuildConfiguration also knows the name of the final image which is pushed into the internal container registry. 

You can view the build process in the console and also on the command line, like this:

```
oc logs bc/vote-app -f 
```

Note how the source code is first cloned, the dependencies are installed and then a new image is committed/pushed into the internal container registry. 

After the build the image will be automatically launched:

```
oc get po
NAME           READY     STATUS      RESTARTS   AGE
vote-1-build   0/1       Completed   0          10m
vote-1-gxq5k   1/1       Running     0          10m
```

The vote-1-build pod has completed that it was doing, namely building the application. 
Now the vote-1-gxq5k pod is running the app.

If not already, expose the app:

```
oc expose svc vote-app
```

Open the app in your browser and check it's working. 

## Update the source code and re-build the app

Now you can update the source code and manually trigger a re-build which will trigger a fresh deployment. 

We will change the definition of the question for the vote.

Go to your source code on Github.  Find the file seeds/seed_data.json and edit it (click on the pen icon).

Append the text 'v2' to the line:

```
   "question": "What is your favourite Linux distribution?",
```

for example:

```
   "question": "v2: What is your favourite Linux distribution?",
```

and save the file by clicking on "Commit changes" button. 

Now you can trigger a new build and follow the progress (--follow --wait) using the following command:

```
oc start-build vote-app --follow --wait 
```

After the image is pushed, see the app build and re-deploy. 

```
watch oc get pod
```

When finished, hit Ctl-C

Once the app is running again, see the app in the browser to verify the changes:

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE

curl $VOTE_APP_ROUTE
```

Now you can roll back to the previous version of the app by simply re-deploying the previous image.

Fist view the history of roll outs for our app:

```
oc rollout history dc vote-app
```

To roll back to the previous version, run the following:

```
oc rollout undo dc vote-app
```

or you can roll back to a specific revision:

```
oc rollout undo dc vote-app --to-revision=1
```

Check the result each time with the browser and the following command:

```
oc get pods
```

**That's the end of the lab.** 

You learned how to build and deploy (and re-build and re-deploy) the app on top of OpenShift itself.  You also learned how to roll back to previous versions.


If you want to try something else try to do all of the above tasks from within the OpenShift console. 



