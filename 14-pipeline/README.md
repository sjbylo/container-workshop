# Getting started with CI/CD

In this lab  you will create a CI/CD Pipeline based on Jenkins.  
The Pipeline is made up of three stages:
- building the app, then
- deploying the app and then
- testing the app. 

If you have not already done do, fetch your source code:

```
git clone https://github.com/YOUR_GITHUB_USERNAME/flask-vote-app.git
```
(don't forget to exchange "YOUR_GITHUB_USERNAME" with your real Github username!)

Ensure you are working in the source code directory:

```
cd flask-vote-app
```

Now, you need to create a new BuildConfig that employs the Jenkins pipeline strategy to build,
deploy and test our example application.

Create the pipeline within OpenShift using the following command:

```
oc create -f openshift/pipeline.yaml
buildconfig.build.openshift.io/vote-app-pipeline created
```

While we wait for the Jenkins pod to launch, take a look at the OpenShift web console.
Go to your project overview, click on the Build menu (left side), then on Pipelines.  
Look at the Jenkinsfile in the configuration and see what the "stages" are and what they do.

Wait for the Jenkins pod to launch (this may take a few minutes the first time).  WARNING: You may need to wait 10 mins or more!

You will see two BuildConfigs now:

```
oc get bc
NAME                TYPE              FROM      LATEST
vote-app            Source            Git       1
vote-app-pipeline   JenkinsPipeline             0
```

There is one more thing we need to do before we get started.  We need to disable automatic deployment when the app image is updated.  This is because we want to give the Jenkins Pipeline control of this process and not OpenShift itself. 

To do this, run this command which removes the "automatic: true" setting in the vote-app DeploymentConfig:

```
oc patch dc vote-app -p "`cat openshift/remove-image-change-trigger.json`"
```
(Ensure you are in the top level of the app source code where the "openshift" directory is.)

Now, start the Pipeline.

View the Pipeline in the Web console.  As described above, navigate via the Menu to the Build->Pipeline screen and click on "Start Pipeline" (on the right side).   View the log and you will see the Jenkins Pipeline progressing.

You can also trigger the Pipeline from the command line, of course:

```
oc start-build vote-app-pipeline 
```


**That's the end of the lab**

If you are interested to try something else, take a look at the below tutorial.  Add a final stage, after the "Test" stage, which scales the app pods to 3.  You can edit the Jenkinsfile directly in the web console. Don't forget to make a backup (cut and paste into a file) of the Jenkinsfile before making any changes!

See the _Jenkins Pipeline Tutorial_ for more information:

https://docs.openshift.com/container-platform/3.11/dev_guide/dev_tutorials/openshift_pipeline.html

