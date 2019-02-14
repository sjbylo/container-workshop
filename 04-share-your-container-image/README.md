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

Now, log in to Quay:

```
docker login -u $MY_QUAY_USER
<enter your password or key>
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
(Note instead of _YOUR_GITHUB_USERNAME_ you should see your own username, of course!).

Now, push (upload) the image to the quay.io container registry. 

```
docker push quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

Now, you need to make the image "public". 

open the Quay.io web console in a browser and log in. The following command will help you know which URL to open.

echo https://quay.io/repository/$MY_QUAY_USER/flask-vote-app?tab=settings

Using the Quay.io web console, go to your new repository, select _Settings_, scroll down and set "Repository Visibility" to "Public".  You should then see "This Repository is currently public and is visible to all users, and may be pulled by all users.". 

## Let Quay.io build the image for you and make it publicly available!

For Quay.io to build the image for you, you need to upload our application's source code and ask Quay to start a new build.

First, you will need to archive the source code directory, then upload the archive file to Quay.io.

To create an archive, you could use this command:

```
cd flask-vote-app     # Ensure your current working directory is our application's source code.
tar czvf ~/vote-app.tgz *
```

Now create a new repository using the Quay web console:

- Go to https://quay.io/repository/
- Click on "+ Create New Repository" and name it "flask-vote-app"
- fill in the form, remember to set "Public" access 
- set "Initialize from a Dockerfile" and then, at the bottom,
- select and upload your archive file (~/vote-app.tgz).
- Click on "Create public repository" 

The build should start.

Can you see the "Building image from Dockerfile" (click on the build ID), showing you the steps taken as the image is built? 

The image should then be made available.

As described above, make the image "public" so others can access it. 

**That's the end of the lab.**

---
Optionally, you might like to try ...

Create a repository in Quay.io using a Git Hub repository as the source.  If you don't have a Git Hub account, create one and then fork the following repository (our source code).  Link this repository with quay.io.

```
https://github.com/sjbylo/flask-vote-app.git
```

To do this, go to Quay.io, create a new repository and link it to *your* forked repository in Git Hub. 


