# Setting up for the workshop

This workhop shows you how to build and use Linux containers on your laptop and then how to run these same container images on OpenShift.

See below for what you need to configure/install before starting these labs.

# What you should bring if you want to follow all of the hands-on labs.

A) Absolute minimum - access OpenShift via WiFi  
- A laptop with a modern up-to-date browser
- Ssh installed, e.g. PuTTY
- Wifi 
- Note: With just this, you can perform all of the OpenShift labs (in the cloud), but not the  Docker based labs on your laptop. 
Register for a free github.com account at https://github.com/join 

B) Best case - install Docker on your laptop 
- A laptop which can run Docker 
- Docker for Windows or Docker for Mac (or on Linux!) installed and working on the laptop 
- It will be very helpful if the following commands complete successfully before coming to the workshop:
- docker pull docker.io/library/centos:7.6.1810 
- docker pull docker.io/library/mysql:5.7.25 
- The following command should output “CentOS Linux…”:
- docker run -it --rm centos:7 cat /etc/redhat-release
- CentOS Linux release 7.6.1810 (Core) 
- Quay.io account 
- Register for a free account at https://quay.io/
- Generate and retrieve your encrypted password from the Settings menu. We will be using it to interact with the Quay registry. 
- Note: With the above, you can perform all of the labs. 

