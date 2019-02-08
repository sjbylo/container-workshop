# Build an image containing the application

If you don't have the application source code already, download the source code from the following URL.

```
https://github.com/sjbylo/flask-vote-app/archive/master.zip
```

Unpack the archive into the current directory and rename it.

```
unzip  flask-vote-app-master.zip
mv flask-vote-app-master flask-vote-app
```

Change directory into the source code folder.

```
cd flask-vote-app
```

Examine the Dockerfile.
Look at each Dockerfile directive, e.g. RUN and COPY etc, to see how a fresh image is built up, layer by layer, on top of the base image FROM centos.  Each directive creates one new layer in the docker image. 

```
cat Dockerfile
```

Build the new image with the following command.
This command will also tag (-t) the new image with the name _flask-vote-app:latest_.
Don't forget the '.' which means build using the files in the current working firectory (our source code). 

```
docker build -t flask-vote-app:latest .
```

This might take a few minitues. Once it's succesfully completed, then continue. 

Launch your fresh image _flask-vote-app:latest_ with the folowing command. 
The command will make the container accessible on port 8080 (-p), name the container _vote-app_ and remove the container after it has stopped (--rm).   As in the previous lab, you should see the python application starting up and then listening on port 8080.

```
docker run -it --rm -p 8080:8080 --name=vote-app flask-vote-app:latest
```

As in the previous labs, test your app but this time it's running in a container.

```
curl http://localhost:8080/
```

The curl command should output HTML which should contain "<title>Favourite Linux distribution</title>". 
If you don't have curl, open the URL in a broswer.

Kill your running container.

```
docker kill vote-app 
```

That's the end of the lab.  

Optionally, you might like to try ...

Using the folowing command, explore inside your running container.

```
docker exec -it vote-app /bin/bash
```

See if you can discover which Linux user the app/container is running as.  Which user ID is it and why? 

