# Add probes to your application

In this lab you will learn how to use probes to improve self-healing of failed pods. Then you will
test the self-healing in action.

Kubernetes checks the health of pods and if a pod should fail, Kubernetes is able to re-start the
pod. By default, Kubernetes monitors only the state of the process running in the container. 

What is the process apears to be running, but actually the application inside has failed?

This is where probes come it. Probes are used to monitor pods in a more specific way. 

Probes can have one of three types:
1. Ports can be checked to see if they are open
1. A Http get reqest can be used to fetch a responce from the application
1. A script can be executed inside the container.  The script can check anything it needs to.

## Create a probe

Use the following command to add a probe to the deployment "dc vote-app". The probe will check if
the vote.html page returns with a responce code of 
200 or not and also within 2 seconds or not.  The probe will only start after an initial delay of 3 seconds, 
giving the application in the pod a chance to start up properly.  `Liveness` means the probe will
check if the pod itself is healthy only.

```
oc set probe dc vote-app --liveness --get-url=http://:8080/vote.html --timeout-seconds=2 --initial-delay-seconds=3
deploymentconfig.apps.openshift.io/vote-app probes updated
```

Due to this configuration change, the pod will be restart.

Now, delete one of the pods.

```
oc get pods
vote-app-22-l4qj4       1/1       Running   0          5m
vote-app-22-n2q8f       1/1       Running   0          5m
vote-app-22-vlmt2       1/1       Running   0          5m
```

```
oc delete pod vote-app-22-l4qj4
```

The pod will be restarted.  Check the status with:

```
watch og get pods
```
Hit CTRL-C to exit from the watch command.

**That's the end of this lab.**

If you are interested, you can try another way to fail the application and test the self-healing.

This command will show the pods and their IP addresses:

```
oc get pod -owide | grep vote-app.*Running
```

Select one of the pod's IP address. And run this command:

```
curl 10.1.5.51:8080/shutdown
```

This will cause the application inside the container to shutdown and become unresponsive.   After a few seconds, the probe
for /vote.html will fail and the container will be automatically restarted inside its pod.  

To see this run the folling:

```
oc describe  po vote-app-23-m5v74

```

You should see output showing the probe failing and the container restarting:

```
Started container
...
Liveness probe failed: Get http://10.1.5.51:8080/vote.html: dial tcp 10.1.5.51:8080: connect: connection refused
...
```

