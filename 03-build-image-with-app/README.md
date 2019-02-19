# Build a container image containing the example application

In this lab you will build a container image for the application using Docker. You will take a look at the Dockerfile which contains 
all the instructions needed to build the application and then you will run the application in a container. 

First, if you don't have the application source code already on your laptop (from a previous lab),
clone the source code using the following URL.

```
git clone https://github.com/ENTER_YOUR_GITHUB_USERNAME_HERE/flask-vote-app.git
```
Remember to clone your own repository that you forked in a previous lab!

Change directory into the source code folder:

```
cd flask-vote-app
```

Examine the Dockerfile:

```
cat Dockerfile
```

Look at each Dockerfile directive, e.g. "RUN" and "COPY" etc, to see how a fresh image is built up, layer by layer, on top of the base image 
"FROM centos".  Each directive creates one new layer in the docker image. 

Build the new image with the following command.

This command will also tag (-t) the new image with the name _flask-vote-app:latest_.
Don't forget the "." (the "build context") which means build using the files in the current working directory (our source code). 

```
docker build -t flask-vote-app:latest .
```

This might take a few minutes. Once it's successfully completed continue with the lab.

Launch your fresh image named _flask-vote-app:latest_ with the following command. 

The command will:
- make the container accessible on port 8080 (-p)
- name the container _vote-app_ and 
- remove the container after it has stopped (--rm). 

Similar to a previous lab, you should see the python application starting up and then listening on port 8080.

IMPORTANT: If you are using Docker on your laptop, use this command (with the option "-p 8080:8080"):
```
docker run -it --rm -p 8080:8080 --name=vote-app flask-vote-app:latest
```

IMPORTANT: If you are using Docker on the server, use this command (without the "-p" option):
```
docker run -it --rm --name=vote-app flask-vote-app:latest
```

Note, at this time you cannot test the application in a container `on the server` as "port bindings are
not yet supported by rootless containers", but you can see if it starts up.

As in the previous labs, test your application - but this time it's running in a container!

```
curl http://localhost:8080/
```

The curl command should output HTML which should contain "<title>Favourite Linux distribution</title>". 
If you don't have curl, open the URL in a browser.

Using another terminal, stop your running container.

```
docker kill vote-app 
```

**That's the end of the lab.**

Workshop contents: https://github.com/sjbylo/container-workshop

Optionally, you might like to try ...

Launch your container again and using the following command, explore inside your running container 
using various Linux commands:

```
docker run -it --rm --name=vote-app flask-vote-app:latest bash
```

Try some commands:

```
ps -ef
ls -l /
id
whoami
exit
```

See if you can discover which Linux user the application/container is running as.  Which user ID is it and why? 

Don't forget to remove your running container again:

```
docker kill vote-app 
docker rm vote-app 
```

