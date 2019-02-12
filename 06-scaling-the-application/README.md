# Add probes 

Use the following command to add a liveness probe to the deployment "dc vote-app". The probe will check if the vote.html page returns 200 or not and also within 2 seconds.  The probe will only start after an initial delay of 3 seconds, giving the application in the pod a chance to start up properly. 

oc set probe dc vote-app --liveness --get-url=http://:8080/vote.html --timeout-seconds=2 --initial-delay-seconds=3

# Scale up and Scale down the application instances

In this exercise we will learn how to scale our application. OpenShift
has the capability to scale your application and make sure that many
instances are always running.

Switch to an existing project

For this exercise, we will be using an already running application. We
will be using the project that you created in the
previous labs. Make sure you are switched to that project by using the
`oc project` command and *remember* to substitute UserName.

```
oc project myproject-UserName
```

View the deployment config

Take a look at the `deploymentConfig` (or `dc`) of the application:

```
oc get deploymentConfig/vote-app -o yaml
FIXME
```

Note that the `replicas:` is set to `1`. This tells OpenShift that when
this application deploys, make sure that there is 1 instance.

```
oc get pods
```

This shows that the build `vote-app-1` is running in pod `FIXME`. Let us
view the `rc` on this build.

```
oc get rc/vote-app-1

NAME          DESIRED   CURRENT   AGE
vote-app-1    1         1         2h
```

## Scale Application

To scale your application we will edit the `deploymentConfig` to 3.

Open your browser to the Overview page and note you only have one
instance running.

FIXME
image::images/scale_updown_overview.png[image]

Now scale your application using the `oc scale` command (remembering to
specify the `dc`)

```
oc scale --replicas=3 dc/vote-app
deploymentconfig "vote-app" scaled
```

If you look at the web console and you will see that there are 3 instances running now

FIXME
image::images/scale_updown_overview_scaled.png[image]

*Note:* You can also scale up and down from the web console by going to
the project overview page and clicking twice on FIXME image::scale_up.jpg[image] right next to the pod count circle to
add 2 more pods.

On the command line, see how many pods you are running now:

```
oc get pods

NAME           READY     STATUS      RESTARTS   AGE
vote-app-1-33wyq   1/1       Running     0          10m
vote-app-1-45jtc   1/1       Running     0          2h
vote-app-1-5ekuk   1/1       Running     0          10m
```

You now have 3 instances of `vote-app-1` running (each with a different
pod-id). If you check the `rc` of the `vote-app-1` build you will see that
it has been updated by the `dc`.

```
oc get rc/vote-app-1

NAME          DESIRED   CURRENT   AGE
vote-app-1    3         3         3h
```

Idling the application

Run the following command to find the available endpoints

```
oc get endpoints
NAME          ENDPOINTS                                            AGE
vote-app      10.128.0.33:8080,10.129.0.30:8080,10.129.2.27:8080   15m
```

Note that the name of the endpoints is `vote-app` and there are three ips addresses for the three pods.

Run the `oc idle endpoints/vote-app` command to idle the application

```
oc idle endpoints/vote-app
Marked service myproject/vote-app to unidle resource DeploymentConfig myproject/vote-app (unidle to 3 replicas)
Idled DeploymentConfig myproject/vote-app (dry run)
```

Go back to the webconsole. You will notice that the pods show up as idled.

FIXME
image::images/idled_pods.jpeg[image]

At this point the application is idled, the pods are not running and no
resources are being used by the application. This doesn’t mean that the
application is deleted. The current state is just saved.. that’s all.

## Reactivate your application

Now click on the application route URL or access the application via curl.

Note that it takes a little while for the application to respond. This
is because pods are spinning up again. You can notice that in the web
console.

In a little while the output comes up and your application would be up with 3 pods.

So, as soon as the user accesses the application, it comes up!!!

## Scaling Down

Scaling down is the same procedure as scaling up. Use the `oc scale` command on the `vote-app` application `dc` setting.

```
oc scale --replicas=1 dc/vote-app

deploymentconfig "vote-app" scaled
```

Alternately, you can go to project overview page and click on the down arrow twice to remove 2 running pods.

Congratulations!! In this exercise you have learned about scaling and
how to scale up/down your application on OpenShift!

