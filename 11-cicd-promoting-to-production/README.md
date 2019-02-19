# Create a CI/CD Pipeline and promote the application into production

In this lab you will continue from the previous lab and create a CI/CD Pipeline which promotes your application into production. 

If you have not already done so complete the previous lab, "Getting started with CI/CD".

Ensure you are working in the source code directory:

```
cd flask-vote-app
```

---
## Create the Pipeline

Now, you need to replace the pipeline with a new one which knows how to promote the application into production.

Recreate the pipeline (`oc replace`) using the following command:

```
oc replace -f openshift/pipeline-full.yaml
buildconfig.build.openshift.io/vote-app-pipeline created
```

Take a look in the OpenShift web console to see the pipeline code.  Go to the Menu on the left under Build->Pipeline->Configuration to see the Jenkins Pipeline code.  There is one more stage added called "Promote to Prod" which waits for input and then promotes (tags) the image into production.

---
## Set up the application in production

Now you need to set up the application for production.

Tag the application image with "prod" to make it available to deploy into production:

```
oc tag vote-app:latest vote-app:prod
```

This will create a new tag ("prod") that's pointing to a specific version of the application.  
This is the version that will run in production.  
This provides fine-grained control of what exactly is running in production. Only if the image is "promoted" by 
tagging it like this, will it run in production. 

Now, with the newly tagged image ("prod"), you can create the production DeploymentConfig which will be responsible for the life cycle of the application in production.

Initialize the production application instance using the image (--image-stream=vote-app:prod) as follows. Note, the name is `vote-app-prod`

```
oc new-app --image-stream=vote-app:prod  --name vote-app-prod
```

Expose the production application on a separate route:

```
oc expose svc vote-app-prod
```

Check the production version of the application is working using your browser or curl:

```
VOTE_APP_ROUTE_PROD=$(oc get route vote-app-prod --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE_PROD
curl $VOTE_APP_ROUTE_PROD
```

You should see the application working.

---
## Run the Pipeline

Let's try out the new pipeline.

Now try the following to show how the pipeline works including a manual step to promote (and deploy) to production:

- change a part of the source code and commit the change to your repository.  How about you edit the file templates/index.html and change the text "Sample Poll Application" to "Sample Poll Application v2" (or similar).  
You can do this using git on the command line or by using the GitHub console by navigating to the file you want to change, clicking on the edit (pencil) icon, make the change  and then click on the "Commit" button.
- Start the Pipeline and let it run until you are asked to promote or not.
- Check the version of the application that is running (not the production version).  It should include the change you just made ("v2").
- Check the version of the application that is running in production.  It should still be running the latest stable version (without the "v2").
- Now promote the application by clicking on the promote application link. The image will be tagged "prod" and the production DeploymentConfig (vote-app-prod) will automatically re-deploy the application into production.
- Check the production version is now running the newer version of the application ("v2").


**That's the end of the lab**

Workshop contents: https://github.com/sjbylo/container-workshop

---


