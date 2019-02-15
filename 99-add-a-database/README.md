# Adding a database 

In this lab you will spin up a database in a pod.  The database pod will be configured to accept
connections via a service object and using the specified credentials (user/password). You will then
change the running application so it can connect to the database. 

## Start the database

First, if you have not yet done so in the previous labs, start the application using the following command:

```
oc new-app python:2.7~https://github.com/sjbylo/flask-vote-app.git --name vote-app 
```

Now, you will use the MySQL container image.  

Let's bring up MySQL, primed with the needed settings.  Again, you can use "oc new-app" to do
this.  The below command pulls and runs the mysql:5.7 image from Docker Hub
(docker.io/library/mysql:5.7.25) and, using the specific environment settings (-e), configurs the database. 

Run this to start MySQL:

```
oc new-app --name db -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=vote mysql:5.7
```

Note, the settings that are defined by `-e` will become environment variable in the database pod.

---
## Connect to the database

After a short while, MySQL will have launched.  But, the vote application will not know how to connect to the
database yet.  To help the application know how to connect you will change the settings of the vote
application.  Luckily, the vote application is able to configure itself via enrionment variables.
You will set these environment variable now via the DeploymentConfig (dc/vote-app) and the
application pod will restart with the new variable in its environment and connect to the MySQL
datbase via the hostnamee "db" and port 3306. 

Run the following command:

```
oc set env dc vote-app DB_HOST=db DB_PORT=3306 DB_NAME=vote DB_USER=user DB_PASS=password
DB_TYPE=mysql
```
Note, you are adding the same settings as before.  These values will be added as environment
variable into the fresh application pod. All application pods will be restarted.

---
## Scale the pod

To ensure we test the application properly, check the application is running with 3 pods. We need to ensure that the state is all stored in the database and not in each individual pod.

```
oc scale --replicas=3 dc/vote-app
```

Wait for all 3 pods to start

```
oc get pods
```

---
## Test the application with the database

Test the application with a browser.

Now, test the application with curl.

If the VOTE_APP_ROUTE varibale is not set (from previous labs), set it with the following:

```
VOTE_APP_ROUTE=$(oc get route vote-app --template='{{.spec.host}}'); echo $VOTE_APP_ROUTE
```

```
curl $VOTE_APP_ROUTE 
```

**That's the end of the lab.**

