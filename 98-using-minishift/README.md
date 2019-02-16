# Using Minishift to complete the labs

If you would like to use Minishift to complete these labs, it is a good idea to load the needed
images into Minishift e.g. from a thumb drive.  That way, you don't need to download them over
shared Internet connection. 

Once Minishift is installed, configured and started, e.g. with the command `minishift start`, you can gain access
to the Docker daemon inside Minishift.  

Copy the needed images to your laptop.

Ensure that `eval $(minishift docker-env)` has been executed so that you have access to Docker
inside of Minishift.  Check that with the command `docker ps` and you should see many openshift
related containers running.  This means you are properly connected to the Minishift Docker daemon.

Import the images into Minishift with the following commands:

```
docker load -i centos7.saved
Loaded image: centos:7

```
docker load -i mysql57.saved
Loaded image: mysql:5.7.15
```

Now, Minishift will not need to pull those images from docker.io because they will be available
locally. 
