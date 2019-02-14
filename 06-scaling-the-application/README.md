# Scale up and Scale down the application instances

In this lab you will learn how to scale our application. OpenShift
has the capability to scale your application and make sure that many
instances are always running.

Switch to an existing project

For this lab, we will be using an already running application. We
will be using the project that you created in the
previous labs. Make sure you have switched to that project by using the
`oc project` command.

```
oc project <your unique project name>
```

View the deployment config.

Take a look at the `deploymentConfig` (or `dc`) of the application:

```
oc get deploymentConfig/vote-app -o yaml
```

Note that the `replicas:` is set to `1`. This tells OpenShift that when
this application deploys, make sure that there is 1 instance.


```
oc get pods
```

Let us view the `rc` on this pod.

```
oc get rc/vote-app-1

NAME          DESIRED   CURRENT   AGE
vote-app-1    1         1         2h
```
Nite that the desired and current values are both 1, so one instance should be running.


## Scale the application

To scale the example application you will edit the `deploymentConfig` to 3.

Open your browser to the Overview page and note you only have one
instance running.

Now scale your application using the `oc scale` command (remembering to specify the `dc`)

```
oc scale --replicas=3 dc/vote-app
DeploymentConfig "vote-app" scaled
```

If you look at the web console you will see that there are 3 instances running now

*Note:* You can also scale up and down from the web console by going to
the project overview page and clicking twice on the arrow right next to the pod count circle to add 2 more pods.

On the command line, see how many pods you are running now:

```
oc get pods

NAME               READY     STATUS      RESTARTS   AGE
vote-app-1-33wyq   1/1       Running     0          10m
vote-app-1-45jtc   1/1       Running     0          2h
vote-app-1-5ekuk   1/1       Running     0          10m
```

You now have 3 instances of `vote-app-1` running (each with a different
pod-id). If you check the `rc` of the `vote-app-1` you will see that 
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

Go back to the web console. You will notice that the pods show up as "idled".

At this point the application is idled, the pods are not running and no
resources are being used by the application. This doesn’t mean that the
application is deleted. The current state is just saved.. that’s all.


## Reactivate the application

Now click on the application route URL or access the application via curl.

Note that it takes a little while for the application to respond. This
is because pods are spinning up again. You can see that in the web
console.

In a little while the output comes up and your application would be up with 3 pods.

So, as soon as the user accesses the application, it comes up!!!


## Scaling Down

Scaling down is the same procedure as scaling up. Use the `oc scale` command on the `vote-app` application `dc` setting.

```
oc scale --replicas=1 dc/vote-app
DeploymentConfig "vote-app" scaled
```

This will also have the effect of unidling the pods.

Alternately, you can go to project overview page and click on the down arrow twice to remove 2 running pods.

Congratulations!! In this lab you have learned about scaling and
how to scale up/down your application on OpenShift!


