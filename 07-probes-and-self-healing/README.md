# Adding probes to your application

In this lab you will learn how to use `probes` to improve the `self-healing` of failed containers. Then you will
test the self-healing in action.

Kubernetes checks the health of containers and is able to re-start a
container if it should fail.  By default, Kubernetes monitors only the state of the process that is 
running within the container.  What if the process appears to be running but actually, the application inside has failed 
and become unresponsive?  Will Kubernetes detect this?  Possibly not!

This is where probes help out.  Probes are used to monitor containers in a way that is more appropriate for 
the application running inside the container. 

Probes come in three flavors:

1. TCP or UDP ports can be checked to see if they are open.
1. An HTTP get request can be used to check for a `200` response.
1. A script can be executed inside the container which can check anything it needs to.

## Create a probe

Use the following command to add a probe to the DeploymentConfig of our application "dc vote-app". 

The probe will check if the `/health` page returns with a response code of 200 or not.
The probe will only start after an `initial delay` of 3 seconds which gives the application a chance to start up properly. 
The `liveness` option means the probe will check if the container itself is healthy.

```
oc set probe dc vote-app --liveness --get-url=http://:8080/health --initial-delay-seconds=3
DeploymentConfig.apps.openshift.io/vote-app probes updated
```

Due to this configuration change, the pod will be restarted automatically. 

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

A new pod will be started again with a new pod ID.  Check the status with:

```
watch oc get pods
```
Hit CTRL-C to exit from the watch command.


## Test a failing application 

Try another way to fail the application and test the self-healing.

You will intentionally cause the application inside the container to fail and become unresponsive.   After a few seconds, the probe
for /health will fail and the container will be automatically restarted inside its pod.  After it is
restarted, the pod will work again. 

Ensure only one pod is running:

```
oc scale --replicas=1 dc/vote-app
```

Fetch the application's URL into a variable:

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE
```

Now, run this command once to cause the application to fail:

```
curl $VOTE_APP_ROUTE/fail
```

To see what's happening, run the following:

```
watch "oc describe po vote-app-23-m5v74 | tail -15"
```
Remember to replace `vote-app-23-m5v74` with your pod's ID!

You should see output similar to the following which shows the probe failing and the container starting up again:

```
Liveness probe failed: HTTP probe failed with status-code: 500
pulling image ...
Successfully pulled image ...
Killing container with id ...
Created container
Started container
```

Notice that after the HTTP probe detected the failure, Kubernetes killed the failing container and
started a fresh container inside the same pod. Note that the pod ID remains the same as it was. 
This was only possible because a probe was used to properly detect the failure.

Had there been no probe defined to properly detect the failure the container would
never be re-started because Kubernetes would always see a running process but not detect any
failure. 

Exit the above `watch` command with CTRL-C.

**That's the end of the lab**

Workshop contents: https://github.com/sjbylo/container-workshop

