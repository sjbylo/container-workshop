# Scale up and scale down the application instances

In this lab you will learn how to scale our application. OpenShift
has the capability to scale your application and make sure that many
instances are always running.

Switch to your existing project.

For this lab, we will be using an already running application. You
will be using the project that you created in the
previous labs. Make sure you have switched to that project by using the
`oc project` command.

```
oc project <your unique project name>
```

View the deployment config.

Take a look at the `DeploymentConfig` (or `dc`) of the application:

```
oc get deploymentConfig/vote-app -o yaml
```

Note that the `replicas:` is set to `1`. This tells OpenShift that when
this application deploys, make sure that there is 1 instance.

View the replication controllers:

```
oc get rc
```

Let us view the `rc` on this pod:

```
oc get rc/vote-app-1

NAME          DESIRED   CURRENT   AGE
vote-app-1    1         1         2h
```

Note that the desired and current values are both 1, so only one instance should be running.

```
oc get pod
NAME               READY     STATUS      RESTARTS   AGE
vote-app-1-33wyq   1/1       Running     0          10m
```


---
## Scale the application

To scale the example application you will change the `deploymentConfig` to 3.

Open your browser to the Overview page and note you only have one instance running.

Now scale your application using the `oc scale` command (remembering to specify the `dc`)

```
oc scale --replicas=3 dc/vote-app
DeploymentConfig "vote-app" scaled
```
(Warning: do not scale to more than 3 pods.).

If you look at the web console you will see that there are 3 instances running now.

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
pod-ids). If you check the `rc` of the `vote-app-1` you will see that 
it has been updated by the `dc`.

```
oc get rc/vote-app-1
NAME          DESIRED   CURRENT   AGE
vote-app-1    3         3         3h
```

Idling the application

Run the following command to find the available endpoints (IP addresses of the three pods):

```
oc get endpoints
NAME          ENDPOINTS                                            AGE
vote-app      10.128.0.33:8080,10.129.0.30:8080,10.129.2.27:8080   15m
```

Note that the name of the endpoint is `vote-app` and there are three IP addresses for the three pods.

Run the `oc idle endpoints/vote-app` command to idle the application

```
oc idle endpoints/vote-app
Marked service myproject/vote-app to unidle resource DeploymentConfig myproject/vote-app (unidle to 3 replicas)
Idled DeploymentConfig myproject/vote-app (dry run)
```

Go back to the web console. You will notice that the pods show up as "idled".  All the pods should
have been stopped. 

At this point the application is idled, the pods are not running and no
resources are being used by the application. This doesn't mean that the 
application is deleted.  The current state is just saved, that's all.


---
## Reactivate the application

Now click on the application route URL or access the application via curl.

Note that it takes a little while for the application to respond. This
is because pods are spinning up again. You can see that in the web
console.

In a little while the output comes up and your application would be up with 3 pods.

So, as soon as the user accesses the application, it comes up!!!


---
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



**That's the end of the lab.**

Workshop contents: https://github.com/sjbylo/container-workshop

---
Optionally, you might like to try ...

See how easy it is to change the application endpoint (route object) to use https instead of http. 
You can change this in the OpenShift web console, so log in.

Go to your project, then to Applications (left menu), then to Routes, select your route called vote-app, click Actions->Edit and see 
if you can find the security option and change from http to https?

Failing that, this can also be done on the command line with the following command!

```
oc patch route vote-app -p '{"spec":{"tls":{"termination":"edge"}}}'
```

Test https is working using the self-signed certificate that is built into OpenShift.

```
curl -k https://$VOTE_APP_ROUTE
```

Remember to switch back from https to http again by removing the `tls` configuration in the route object.

```
oc patch route vote-app --type json -p '[{ "op": "remove", "path":"/spec/tls"}]'
```

check that http is working again:

```
curl http://$VOTE_APP_ROUTE
```


