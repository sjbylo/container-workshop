# Add probes to your application

In this lab....  FIXME

Use the following command to add a liveness probe to the deployment "dc vote-app". The probe will check if the vote.html page returns 
200 or not and also within 2 seconds.  The probe will only start after an initial delay of 3 seconds, 
giving the application in the pod a chance to start up properly. 

oc set probe dc vote-app --liveness --get-url=http://:8080/vote.html --timeout-seconds=2 --initial-delay-seconds=3

