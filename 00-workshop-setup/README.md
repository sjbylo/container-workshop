# Getting ready for the workshop

This workshop shows you how to build and use Linux containers and then how to run and manage these 
same container images on OpenShift.

You should have already installed and configured the prerequisite software.  If you have not, please
see below ("What you should do before...").

---
## Fork the example application repository in GitHub

In some labs you are asked to make changes to the example application's source code. It is important you use your
`own copy of the Git Hub repository`. 

If not already, fork (copy) the example application repository so that you can make
source code changes.

1. Log into your own GitHub account (or create one) then
1. go to the example repository located here: https://github.com/sjbylo/flask-vote-app 
1. Click on the "Fork" button on the top right of the page. (Note, only work from "sjbylo").

GitHub will make a copy and you will see your own version of it in your own GitHub account.
Check that the URL now contains your GitHub username and no longer "sjbylo"!
Later on in the labs you will be asked to access your repository.  
To help you get the URL, click on the 'Clone or download" button and copy & paste the URL into your
terminal when asked to.

Your repository's URL will look something like this:

```
https://github.com/ENTER_YOUR_GITHUB_USERNAME_HERE_HERE/flask-vote-app.git
```
`In the labs, always remember to enter your own Git Hub username.`

Later on in the labs, you will be asked to clone your source code using git. 
Don't worry if you don't have git installed on your laptop, you can use git inside the online lab environment.


## Use Docker on the provided server or on your laptop

`You should only use Docker running on your laptop... if you have already pulled the needed image,
as described below`

Otherwise, please use the `server provided`.  See the "Workshop notes" document, provided by the
trainer. 

---
## What you should do before following all of the hands-on labs.

You should have already completes these steps before coming to the workshop.

A) Absolute minimum requirements - access Docker & OpenShift via WiFi  
- A laptop with a modern up-to-date browser
- Ssh installed, e.g. PuTTY (for windows) 
- Wifi 
- Register for a free github.com account at https://github.com/join 
- A Quay.io account 
    - Register for a free account at https://quay.io/

B) For the adventurous - install Docker on your laptop 
- A laptop which can run Docker 
    - Docker for Windows or Docker for Mac (or on Linux!) installed and working on the laptop 
- It will be very helpful if the following commands complete successfully before coming to the workshop:
    - docker pull docker.io/library/centos:7.6.1810 
    - docker pull docker.io/library/mysql:5.7.25 
- The following command should output "CentOS Linux":
    - docker run -it --rm centos:7 cat /etc/redhat-release
    - CentOS Linux release 7.6.1810 (Core) 

