# Zero down time canary deployment example

In this lab you will see how OpenShift can help you execute a canary deployment.  The same method
can also be used for blue-green deployments.

## Deploy an example application

First of all deploy an example application `hello-openshift` called `prod` by creating a deployment configuration object (DC):

```
oc run prod --image=openshift/hello-openshift --replicas=3
```

The DC creates a replication controller (RC) which starts the 3 pods:

```
oc get pod
```

Reconfigure the application to reply differently by changing the environment in the DC:

```
oc set env dc/prod RESPONSE="Hello from Prod"
```

This will re-deploy the application.  The 3 pods will be replaced.  


Create a service object by exposing the DC:

```
oc expose dc/prod --port=8080
```

```
oc get svc
```

Expose the application externally, creating a route:

```
oc expose svc/prod
```

```
oc get route 
```

## Deploy a "new" version of the application

Now, add a new version of the application, called `canary`:

```
oc run canary --image=openshift/hello-openshift
```

Set the canary version of the application to reply differently:

```
oc set env dc/canary RESPONSE="Hello from Canary"
```

```
oc expose dc/canary --port=8080
```

Set all traffic to go to the current version, `prod`:

```
oc set route-backends prod   
```

```
oc set route-backends prod prod=100 canary=0
```

## Show canary deployment

Now, test the application to show the behavior.

Fetch the route into a variable you can use later:

```
APP_ROUTE=`oc get route prod -o jsonpath='{.spec.host}{"\n"}'`
```

Test the application, showing that all requests are sent to the production version:

```
while true; do curl http://$APP_ROUTE/; sleep .2; done
```

Now configure so that 10% of requests are sent to the canary version of the application:

```
oc set route-backends prod prod=90 canary=10
```

Test the application, showing that 90% of requests are sent to the production version and about 10%
are sent to the canary version:

```
while true; do curl http://$APP_ROUTE/; sleep .2; done
```

**That's the end of the lab**
---

In case you are interested, try the same again, but this time for a blue-green deployment. 

A Blue-green deployment is a technique that reduces down time and risk by running two identical
production environments called Blue and Green. At any time, only one of the environments is live,
with the live environment serving all production traffic.  

Read more here: https://martinfowler.com/bliki/BlueGreenDeployment.html 



