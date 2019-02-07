# Build an image with the app inside 

If you don't have the application source code already, fetch the source code from the following URL.

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

Examine the Dockerfile.  Look at each Dockerfile directive, e.g. RUN and COPY to see how they build a fresh image from the base image FROM centos.

```
cat Dockerfile
```

Build the new image with the following command which will also tag (-t) the new image with the name flask-vote-app:latest. Don't forget the '.' which means build using the current working firectory. 

```
docker build -t flask-vote-app:latest .
```

Launch your fresh image, forward the port 8080, name the container "vote-app" and remove the container after it is stopped (--rm).   You should see the python application starting up and then listening. 

```
docker run -it --rm -p 8080:8080 --name=vote-app flask-vote-app:latest
```

As in the previous labs, test your running container.

```
curl http://localhost:8080/
```

The curl command should output HTML which should contain "<title>Favourite Linux distribution</title>". 
If you don't have curl, open the URL in a broswer.

Kill your running container.

```
docker kill vote-app 
```

