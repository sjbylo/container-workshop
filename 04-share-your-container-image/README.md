# Share your container image 

To share your image you need to upload it to a *container registry*.  _docker.io_ is probably one you could use. 
For these labs we will use _quay.io_ because it also has some very interseting features, e.g. automatic security vulnerability scanning of your images. 

If not already, sign up for a free account at http://quay.io/.  You will need to log into quay.io from the docker command line, so remember your username and password.  Alternatively, if you wish, you can fetch a key from the Quay console which is a little more secure. 

Log into Quay.io.   First set your username in a variable, then log in.

```
MY_QUAY_USER=<add your quay username here>
docker login -u $MY_QUAY_USER
<enter your password or key>
Login Succeeded
```

Once you see _Login Succeeded_ then continue.

Tag your image so that it matches the *_destination_*.  This is the docker "pull spec" and shows docker where to push (upload) the image to.  Note, you are re-usinf the variable holding your username. 

```
docker tag flask-vote-app:latest quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

Push (upload) the image to the quay.io container registry. 

```
docker push quay.io/$MY_QUAY_USER/flask-vote-app:latest
```

Now, open the Quay.io web console in a browser and log in. The following command will show you which URL to open.

echo https://quay.io/repository/$MY_QUAY_USER/flask-vote-app?tab=settings

Using the Quay.io web console, go to your new rpository, select _Settings_, scroll down and set "Repository Visibility" to "Public".  You should then see "This Repository is currently public and is visible to all users, and may be pulled by all users.". 


