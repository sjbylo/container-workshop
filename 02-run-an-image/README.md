# Run a docker image

First of all check that Docker is running by listing all running containers. 

```
docker ps 
```

If you see an error message like the following, you need to start Docker first.

```
docker: Cannot connect to the Docker daemon ... Is the docker daemon running?
```

The following command will launch the centos version 7 image, connect it to the current terminal (-it) and run the echo command.

```
docker run -it --rm centos:7 echo "Hello World"
```

You should see the following output if the image if launched properly. 

```
Hello World
```

You can also try running the following to get a command line prompt of the running centos container.

```
docker run -it --rm centos:7 bash
```

Type the folowing to exit from the running container

```
exit
```





cat Dockerfile

docker build -t flask-vote-app:latest .

docker run -it --rm -p 8080:8080 --name=vote-app flask-vote-app:latest

docker kill vote-app 




