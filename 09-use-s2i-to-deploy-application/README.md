# Use Source 2 Image to build and launch the application on OpenShift 

In this lab you will enable OpenShift to build our application directly on OpenShift itself. This is done using Source 2 Image (s2i) 
which does the following:

1. Launches a container from a "builder image" of the matching runtime.  In this case that's a python 2.7 builder image.
1. Executes a build of the application in the running builder container.  After a successful build, s2i commits a new image containing the application. 
1. The image is pushed into the internal registry of OpenShift. 
1. The container is launched since the DeploymentConfig is configured to launch or re-launch the container if the image is added or updated. 

Important: First, you must create a fresh project to complete this and the following labs.

```
oc new-project <provide another unique cluster-wide project name>
```
After the project has been created, you will be placed into that project.

You can check this using:

```
oc project
```

You can list your projects with:

```
oc projects
```

You can change to a different project using:

```
oc project <your project name>
```

---
## Launch the application using s2i

"oc new-app" is the command that can initialize an application on OpenShift. 
This command will use the builder image (python:2.7) and run s2i against the source code, fetched from GitHub. 

Run the following command to set up s2i for our application.  "oc new-app" is the command that can initialize an application on OpenShift. 

```
oc new-app python:2.7~https://github.com/ENTER_YOUR_GITHUB_USERNAME_HERE/flask-vote-app.git --name vote-app
```

This command will create a build object called a BuildConfiguration (BC).  The BuildConfiguration knows where to fetch the builder image 
and the source code from. The BuildConfiguration also knows the name of the final image which is pushed into the internal container 
registry. 

You can view the build process in the console and also on the command line, like this:

```
oc logs bc/vote-app --follow 
```

Note, how the source code is first cloned, the python dependencies are installed and then a new image is committed/pushed into the internal container registry. 

After the build the image will be automatically launched.

Check it out:

```
oc get po
NAME           READY     STATUS      RESTARTS   AGE
vote-app-1-build   0/1       Completed   0          10m
vote-app-1-gxq5k   1/1       Running     0          10m
```

The vote-app-1-build pod has completed what it was doing, namely building the application. 
Now the vote-app-1-gxq5k pod is running the application.

If not already, expose the application to the external network:

```
oc expose svc vote-app
```

Open the application in your browser and check it's working. 


## Update the source code and re-build the application

Now you can update the source code and manually trigger a re-build which will also trigger a fresh deployment. 

We will change the definition of the `question` that the vote-app asks.

Go to your source code on GitHub.  Find the file seeds/seed_data.json and edit it (click on the pen icon).

Append the text 'v2' to the line:

```
   "question": "What is your favourite Linux distribution?",
```

for example, it will then look like this:

```
   "question": "v2: What is your favourite Linux distribution?",
```

and save the file by clicking on the "Commit changes" button. 

Now you can trigger a new build and follow the progress (--follow --wait) using the following command:

```
oc start-build vote-app --follow --wait 
```

After the application is built and the image is pushed in the internal registry, the application is
then re-deployed. 

```
watch oc get pod
```
(When finished, hit CTL-C)

Once the application is running again, see the application in the browser to verify the changes:

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE

curl $VOTE_APP_ROUTE
```

Now you can roll back to the previous version of the application by simply re-deploying the previous image.

Fist view the history of rollouts for our application:

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

Check which version of the application is actually running each time with the browser and with the following command:

```
oc get pods
```

You learned how to build and deploy (and re-build and re-deploy) the application on top of OpenShift itself.  You also learned how to roll back to previous versions.

**That's the end of the lab.** 


If you want to try something else try to do all of the above tasks from within the OpenShift console. 


