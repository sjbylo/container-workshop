# Share your container image 

In this lab you will upload your image into a container registry so that others can also use it and
also  so you can later import it into OpenShift.

**Note: If you encounter problems uploading your image due to network connectivity issues, don't 
worry because there is also another way to build the container image directly on the Quay servers.**.

To share your image you need to upload it to a *container registry*.  _Docker.io_ is probably one
you might know and choose. 
Though, for these labs we will use _quay.io_ because it also has some very interesting features, e.g. building your container 
image and also automatic security vulnerability scanning of your images. 

If not already, sign up for a free account at http://quay.io/.  You will need to log into quay.io from the docker command line, so 
remember your username and password.  (Alternatively, if you wish, you can create an encrypted password in the Quay account 
settings for added security).

Log into Quay.io.   First set your username in a variable for later use. 

```
MY_QUAY_USER=<add your quay username here>
```

Just to to sure, this command should output your username:

```
echo $MY_QUAY_USER
```

Now, log into Quay:

```
docker login -u $MY_QUAY_USER quay.io
<enter your quay password or key>
Login Succeeded
```

When you see _Login Succeeded_ you can continue.

Tag your image so that it matches the *_destination_*.  This is the docker "pull spec" and shows docker where to push (upload) the image to.  (Note, you are re-using the $MY_QUAY_USER variable which holds your Quay username).

```
docker tag flask-vote-app:latest quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

Check that your image has been tagged properly.  You should see your images listed.

```
docker images | grep vote
flask-vote-app                                    latest              a1e10cb408e6        19 hours ago        349 MB
quay.io/YOUR_GITHUB_USERNAME/flask-vote-app       latest              a1e10cb408e6        19 hours ago        349 MB
```

Notice that the image IDs (3rd column) are the same.  That's because we have created only one image but with two different tags. 
(Note, instead of _YOUR_GITHUB_USERNAME_ you should see your own username, of course!).

---
## Push the image into the registry

Warning: This step might be difficult, especially if you are doing it over a shared network.  If this does not work, don't worry,
bellow is a way to build the image directly on the Quay servers. 

Now, push (upload) the image to the quay.io container registry. 

```
docker push quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

By default, the images on Quay are private.  Now, you need to make the image "public". 

Open the Quay.io web console in a browser and log in. The following command will help you know which URL to open.

```
echo https://quay.io/repository/$MY_QUAY_USER/flask-vote-app?tab=settings
```

Using the Quay.io web console:
1. go to your new repository
1. select _Settings_
1. scroll down and set "Repository Visibility" to "Public". 

You should then see "_This Repository is currently public and is visible to all users, and may be
pulled by all users._". 


---
## Let Quay.io build the image for you and make it publicly available!

For Quay.io to build the image for you, you need to link Quay with *your* Github source code
repository.

Create a repository in Quay.io using a GitHub repository URL _as the source_.  If you don't have a GitHub account, 
create one and then use the following repository (your source code).  Link this repository with quay.io.

```
https://github.com/YOUR_GITHUB_USERNAME/flask-vote-app.git
```

To do this, go to Quay.io, create a new repository and link it to *your* forked repository in GitHub. 

Now create a new repository using the Quay web console:

1. Go to https://quay.io/repository/
1. Click on "+ Create New Repository" and name it "flask-vote-app"
1. fill in the form, remember to set "Public" access 
1. choose "Link to a GitHub Repository Push"
1. Click on "Create public repository" 
  1. Note "You will be redirected to authorize for GitHub Repository Push once the repository has
been created"
1. On the next "Setup Build Trigger" page:
  1. select the Github organisation. Click "Continue"
1. Select the repository "flask-vote-app"
1. Click Continue
1. Leave "Trigger for all branches and tags" as default and
1. CLick Contnue 
1. Select "/Dockerfile" as the path to dockefile
1. Click on Continue 
1. Context should be "/"
1. Click on Continue until it's complete!

You can start the build, either by clicking on the 'Start New Build" button or by commiting your
code changes with git.

The build should start.

Can you see the "Building image from Dockerfile" (click on the build ID), showing you the steps taken as the image is built? 

The image should then be made available.

As described above, make the image "public" so others can access it. 

**That's the end of the lab.**

---
Optionally, you might like to try ...

After your images have been uploded to Quay, check to see if they have been scanned for any
vulnerabilities or is they are still in the queue.  If so, what vulnerabilities are found and how
might you fix that? 


