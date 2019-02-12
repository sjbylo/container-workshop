# Build an image containing the application

In this lab you will build the application using Docker. You will take a look at the Dockerfile which contains all the instructions needs to build our application and then you will run the application in a container. 

First, if you don't have the application source code already on your laptop (from previous lab),
download the source code zip file from the following URL.

```
https://github.com/sjbylo/flask-vote-app/archive/master.zip
```

Unpack the archive into the current directory and rename it:

```
unzip  flask-vote-app-master.zip
mv flask-vote-app-master flask-vote-app
```

Change directory into the source code folder:

```
cd flask-vote-app
```

Examine the Dockerfile:

```
cat Dockerfile
```

Look at each Dockerfile directive, e.g. RUN and COPY etc, to see how a fresh image is built up, layer by layer, on top of the base image FROM centos.  Each directive creates one new layer in the docker image. 

Build the new image with the following command.

This command will also tag (-t) the new image with the name _flask-vote-app:latest_.
Don't forget the '.' ("build context") which means build using the files in the current working directory (our source code). 

```
docker build -t flask-vote-app:latest .
```

This might take a few minutes. Once it's successfully completed, then continue with the lab.

Launch your fresh image _flask-vote-app:latest_ with the following command. 
The command will make the container accessible on port 8080 (-p), name the container _vote-app_ and remove the container after it has stopped (--rm).   You should see the python application starting up and then listening on port 8080.

```
docker run -it --rm -p 8080:8080 --name=vote-app flask-vote-app:latest
```

As in the previous labs, test your app but this time it's running in a container.

```
curl http://localhost:8080/
```

The curl command should output HTML which should contain "<title>Favourite Linux distribution</title>". 
If you don't have curl, open the URL in a browser.

Kill your running container.

```
docker kill vote-app 
```

**That's the end of the lab.**

Optionally, you might like to try ...

Launch your container again and using the following command, explore inside your running container using various Linux commands:

```
docker exec -it vote-app /bin/bash
ps -ef
ls -l /
id
exit
```

See if you can discover which Linux user the app/container is running as.  Which user ID is it and why? 

Don't forget to remove your running container again:

```
docker kill vote-app 
```

