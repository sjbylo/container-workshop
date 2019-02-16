# Zero downtime canary deployment 

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
You should see a new service object with the name `prod`

Expose the application externally, creating a route:

```
oc expose svc/prod
```

```
oc get route 
```
You should see a new route object with the name `prod`

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
You should see a new service object with the name `canary`

Set all traffic to go to the current version, `prod`:

```
oc set route-backends prod   
NAME         KIND     TO    WEIGHT
routes/prod  Service  prod  100
```
This shows that, by default, 100% of traffic is passed to `prod`.

```
oc set route-backends prod prod=100 canary=0
```
Now, this explicitly configures the amount of traffic that should go to `prod` and to `canary`.

Take a look at the web console and you will see a graph showing how the traffic is split (`Traffic
Split`). 


## Show canary deployment

Now, test the application to show the behavior.

Fetch the route into a variable you can use later:

```
APP_ROUTE=`oc get route prod -o jsonpath='{.spec.host}{"\n"}'`; echo $APP_ROUTE
prod-myproject.apps.xyz.openshiftworkshop.com
```

Test the application, showing that all requests are sent to the production version:

```
for i in {0..15}; do curl http://$APP_ROUTE/; sleep .2; done
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
```

Now configure it so that 10% of requests are sent to the canary version of the application:

```
oc set route-backends prod prod=90 canary=10
```
Take a look at the web console to see the changes to the graph.

Test the application, showing that 90% of requests are sent to the production version and 10%
are sent to the canary version:

```
for i in {0..15}; do curl http://$APP_ROUTE/; sleep .2; done
Hello from Canary
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Canary
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
Hello from Prod
```

**That's the end of the lab**
---

In case you are interested, try the same again, but this time for a blue-green deployment. 

A Blue-green deployment is a technique that reduces downtime and risk by running two identical
production environments called Blue and Green. At any time, only one of the environments is live,
with the live environment serving all production traffic.  

Read more here: https://martinfowler.com/bliki/BlueGreenDeployment.html 



