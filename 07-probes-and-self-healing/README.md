# Adding probes to your application

In this lab you will learn how to use `probes` to improve the `self-healing` of failed containers. Then you will
test the self-healing in action.

Kubernetes checks the health of containers and is able to re-start the
container if the container should fail.  By default, Kubernetes monitors only the state of the process that is 
running in the container.  What if the process appears to be running, but actually the application inside has failed and become unresponsive?
Will Kubernetes detect this?

This is where probes help out. 
Probes are used to monitor containers in a way that is more appropriate for the application running inside the container. 

Probes come in three falvours:

1. Ports can be checked to see if they are open.
1. An http get request can be used to try and fetch a response from the application.
1. A script can be executed inside the container.  The script can check anything it needs to.


---
## Create a probe

Use the following command to add a probe to the DeploymentCOnfig of our application "dc vote-app". The probe will check if
the /health page returns with a response code of 200 or not and also within 2 seconds or not.  
The probe will only start after an initial delay of 3 seconds, giving the application in the container a chance to start up properly. 
`Liveness` means the probe will check if the container itself is healthy.

```
oc set probe dc vote-app --liveness --get-url=http://:8080/health --timeout-seconds=2 --initial-delay-seconds=3
DeploymentConfig.apps.openshift.io/vote-app probes updated
```

Due to this configuration change, the pod will be restarted.

---
## Test a failing pod

Now, delete one of the pods to simulate pod failure. 

```
oc get pods
vote-app-22-l4qj4       1/1       Running   0          5m
vote-app-22-n2q8f       1/1       Running   0          5m
vote-app-22-vlmt2       1/1       Running   0          5m
```

```
oc delete pod vote-app-22-l4qj4
```

The pod will be started again.  Check the status with:

```
watch oc get pods
```
Hit CTRL-C to exit from the watch command.


---
## Test a failing application 

Try another way to fail the application and test the self-healing.

This command will show the pods and their IP addresses:

```
oc get pod -owide | grep vote-app.*Running 
```

Select one of the pod's IP addresses and run this command to cause the applicaton to fail:

```
curl 10.1.5.51:8080/fail
```
_Don't forget to replace the IP address with the IP address of your selected pod._

This will cause the application inside the container to fail and become unresponsive.   After a few seconds, the probe
for /health will fail and the container will be automatically restarted inside its pod.  

To see this in action, run the following a few times:

```
oc describe po vote-app-23-m5v74
```

You should see output showing the probe failing and the container starting up again, similar to the
following:

```
Liveness probe failed: HTTP probe failed with statuscode: 500
pulling image ...
Successfully pulled image ...
Killing container with id ...
Created container
Started container
```

Note that, beacuse the application itself failed, the container was killed and started again inside
the same pod.

**That's the end of this lab.**

