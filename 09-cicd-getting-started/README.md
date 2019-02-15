# Getting started with CI/CD

In this lab  you will create a CI/CD Pipeline based on Jenkins.  

The Pipeline is made up of three stages:
- building the application, then
- deploying the application and then
- testing the application. 

If you have not already done do, fetch your source code:

```
git clone https://github.com/YOUR_GITHUB_USERNAME/flask-vote-app.git
```
(don't forget to replace "YOUR_GITHUB_USERNAME" with your real GitHub username!)

As usual, ensure you are working in the source code directory:

```
cd flask-vote-app
```

---
## Create your first CI/CD Pipeline

Now, you need to create a new BuildConfig that employs the Jenkins pipeline strategy to build,
deploy and test our example application.  When we do this, Jenkins will be automatically launched and set up for you.

Create the pipeline within OpenShift using the following command:

```
oc create -f openshift/pipeline.yaml
buildconfig.build.openshift.io/vote-app-pipeline created
```

While we wait for the Jenkins pod to launch, take a look at the OpenShift web console.

Go to your project overview, click on the "Build" menu (left side), then on "Pipelines".  
Look at the Jenkinsfile in the configuration and view the pipeline "stages" and see what they do.

Wait for the Jenkins pod to launch (this may take a few minutes the first time).  WARNING: You may need to wait 10 mins or more! Please be patient.

You will see two BuildConfigs now:

```
oc get bc
NAME                TYPE              FROM      LATEST
vote-app            Source            Git       1
vote-app-pipeline   JenkinsPipeline             0
```

---
## Disable automatic triggers 

There is one more thing we need to do before can use the CI/CD pipeline.  We need to disable automatic deployment when the application 
image is updated.  This is because we want to give the Jenkins Pipeline control of this process and not OpenShift itself. 

To do this, run this command which removes the "automatic: true" setting in the vote-app DeploymentConfig:

```
oc set triggers dc vote-app --manual
```

---
## Start the Pipeline

Now, you can start the Pipeline!

View the Pipeline in the Web console.  As described above, navigate via the Menu to Build->Pipeline and click on 
"Start Pipeline" (on the right side).   Wait a few seconds and then view the log and you will see the Jenkins Pipeline progressing.

Wait for the Pipeline to complete.

You can also trigger the Pipeline from the command line, of course:

```
oc start-build vote-app-pipeline 
```


**That's the end of the lab**

If you are interested to try something else, take a look at the below tutorial.  Add a final stage, after the "Test" stage, which 
scales the application pods to 3.  You can edit the Jenkinsfile directly in the web console. Don't forget to make a backup 
(cut and paste into a file) of the Jenkinsfile before making any changes!

See the _Jenkins Pipeline Tutorial_ for more information:

https://docs.openshift.com/container-platform/3.11/dev_guide/dev_tutorials/openshift_pipeline.html


