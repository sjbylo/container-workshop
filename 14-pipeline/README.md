# Create an automated CI/CD Piepline 

In this lab ...



If not already, fetch the souce code


```
git clone https://github.com/your_github_username/flask-vote-app.git
cd flask-vote-app
```
(don't forget to exchange "your_github_username" with your real Github username!)

Now, you need to create a new BuildConfig of the JenkinsPipeline type 
that employs the Jenkins pipeline strategy to build, deploy, and scale our example application.

Create the pipeline within OpenSHift using the following command:

```
oc create -f openshift/pipeline.yaml
buildconfig.build.openshift.io/vote-app-pipeline created
```

Whilst we wait for the Jenkins pod to launch let's take a look at the OpenShift web console.
Go to your project overview, click on the Build menu (left side), then on Pipelines.  
Look at the Jenkinsfile in the configuration and see what the "stages" are and what they do.

Wait for the Jenkins pod to launch (this may take a few minutes the first time).

You will see two BuildConfigs now:

```
oc get bc
NAME                TYPE              FROM      LATEST
vote-app            Source            Git       1
vote-app-pipeline   JenkinsPipeline             0
```

Now, start the Pipeline from the Web console.  Again, as described above, navigate via the Menu to the Build->Pipeline screen and click on "Start Pipeline" (on the right side). 

You can also trigger the Pipeline from the command line, of course:

```
oc start-build vote-app-pipeline --follow --wait 
```


**That's the end of the lab**

See the Jenkins Pipeline Tutorial for more information:

https://docs.openshift.com/container-platform/3.11/dev_guide/dev_tutorials/openshift_pipeline.html

