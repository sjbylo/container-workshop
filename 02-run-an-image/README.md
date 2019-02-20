# Run a docker image

`If you are using docker on your laptop, please continue.  If you are using the server, please
first ensure you have logged into the server following the instructions provided by the trainer.`

In this lab you will launch a Docker container image. 

First of all check that Docker is running by listing all running containers. 

```
docker ps 
```

If you see an error message like the following, you need to install & start Docker first.

```
docker: Cannot connect to the Docker daemon ... Is the docker daemon running?
```

The following command will launch the centos 7 image as a running container and then run the "echo"
command which simply outputs some text and then exit. 

```
docker run --rm centos:7 echo Hello World
```

You should see the following output if the image if launched properly. 

```
Hello World
```

You can also try running the following command which will connect your terminal (-it) with the running container.
You will see a command line prompt ("#") running "inside" the container:

```
docker run -it --rm centos:7 bash
```

Try out some Linux commands in your running container:

```
ls -l
ps -ef
df /
```

Note that you are logged into the container as root. 

You should have quite a lot of root privileges within the
container, but only within the container. Nevertheless it is not a best practice to run containers
as root and this is something that is not allowed by default in OpenShift. 
If you could somehow use your root privileges _outside of the container_ (escape the container) on the underlying host (your laptop or 
other machine) then that might pose a huge problem.  That is why the underlying container technology that is 
running in the host Linux OS must be secure. 

Yes!  Your container is running on Linux, even though you are running Docker on Windows or on a Mac
laptop. This is because Containers are Linux!

https://www.redhat.com/en/blog/containers-are-linux


**That's the end of the lab.**

Workshop contents: https://github.com/sjbylo/container-workshop

---
