# Share your container image 

**Note: If you encounter problems uploading your image due to network connectivity issues, don't worry because the next labs can use another identical image which is already available**.

To share your image you need to upload it to a *container registry*.  _Docker.io_ is probably one you could use. 
Though, for these labs we will use _quay.io_ because it also has some very interesting features, e.g. automatic security vulnerability scanning of your images. 

If not already, sign up for a free account at http://quay.io/.  You will need to log into quay.io from the docker command line, so remember your username and password.  (Alternatively, if you wish, you can fetch a key from the Quay console which is a little more secure).

Log into Quay.io.   First set your username in a variable for later use. 

```
MY_QUAY_USER=<add your quay username here>
```

Now, log in. 

```
docker login -u $MY_QUAY_USER
<enter your password or key>
Login Succeeded
```

Once you see _Login Succeeded_ then continue.

Tag your image so that it matches the *_destination_*.  This is the docker "pull spec" and shows docker where to push (upload) the image to.  (Note, you are re-using the $MY_QUAY_USER variable holding your username).

```
docker tag flask-vote-app:latest quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

Check that your image has been tagged properly.  You should see your images listed.

```
docker images | grep vote
flask-vote-app                                    latest              a1e10cb408e6        19 hours ago        349 MB
quay.io/sjbylo/flask-vote-app                     latest              a1e10cb408e6        19 hours ago        349 MB
```

Notice that the image IDs (3rd collumn) are the same.  That's because we have created only one image but with two different tags. 
(Note instead of _sjbylo_ you should see your own username, of course!).

Now, push (upload) the image to the quay.io container registry. 

```
docker push quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

Now, open the Quay.io web console in a browser and log in. The following command will help you know which URL to open.

echo https://quay.io/repository/$MY_QUAY_USER/flask-vote-app?tab=settings

Using the Quay.io web console, go to your new repository, select _Settings_, scroll down and set "Repository Visibility" to "Public".  You should then see "This Repository is currently public and is visible to all users, and may be pulled by all users.". 

## Let Quay.io build the image for you and make it publicly available!

For Quay.io to build the image for you, you need to upload our app's source code and start a new build.

First, you will need to archive the source code directory, then upload it to Quay.io.

To create an archive, you could use this command.

```
cd flask-vote-app     # Ensure your current working directory is our app's source code.
tar czvf ~/vote-app.tgz *
```

Now create a new repository using the Quay web console:

- Click on "+ Create New Repository" at https://quay.io/repository/ naming it "flask-vote-app" and 
- fill in the form. 
- Remember to set "Public" access 
- "Initialize from a Dockerfile" and then, at the bottom,
- select and upload your archive file (~/vote-app.tgz).

The build should start.

Can you see the "Building image from Dockerfile" (click on the build ID), showing you the steps taken as the image is built? 

The image should then we made available.

That's the end of the lab.  

