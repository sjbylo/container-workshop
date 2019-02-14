# Setting up for the workshop

This workshop shows you how to build and use Linux containers on your laptop and then how to run and manage these same container images on OpenShift.

See below ("What you should do before...") for what you need to configure/install before starting these labs.

## Fetch the container (Docker) images you need for this workshop

Ensure Docker is installed and running on your laptop.  See below instructions "What you should do before...".

If you have not done so already, pull the needed image as described below.

Alternatively, if pulling the images is not possible for any reason, the instructor will provide you with the needed image files
which you can copy onto your laptop and then load into Docker as follows:

```
docker load -i centos7.saved
Loaded image: centos:7
```

```
docker load -i mysql57.saved
Loaded image: mysql:5.7.15
```


---
## Fork the example application repository in GitHub

First you need to fork the example application repository.  
Log into your own GitHub account (or create one), then go to the example repository located here:

```
https://github.com/sjbylo/flask-vote-app 
```

Notice that the example application belongs to GitHub user "sjbylo".  Because you will be required to make changes to the source code, 
it is important you *do not* use this repository directly, but that you _fork_ (copy) it and work with your own copy.

Click on the "Fork" button.

GitHub will make a copy and you will see your own version of it in your own GitHub account.
Check that the URL now contains your GitHub username and no longer "sjbylo"!
Later on in the labs you will be asked to access your repository.  
To help you get the URL, click on the 'Clone or download" button and copy & paste the URL into your terminal when ask to.

Your repository's URL will look something like this:

```
https://github.com/YOUR_GITHUB_USERNAME/flask-vote-app.git
```

Later on in the labs, you will be asked to clone your source code.  Don't worry if you don't have git installed on your 
laptop, you will be able to use git inside the online lab environment.


---
## What you should do before following all of the hands-on labs.

A) Absolute minimum requirements - access OpenShift via WiFi  
- A laptop with a modern up-to-date browser
- Ssh installed, e.g. PuTTY (for windows) 
- Wifi 
- Register for a free github.com account at https://github.com/join 
- Note: With just this, you can perform all of the OpenShift labs (in the cloud or with Minishift), but not the Docker based labs on your laptop. 

B) Best case - install Docker on your laptop 
- A laptop which can run Docker 
    - Docker for Windows or Docker for Mac (or on Linux!) installed and working on the laptop 
- It will be very helpful if the following commands complete successfully before coming to the workshop:
    - docker pull docker.io/library/centos:7.6.1810 
    - docker pull docker.io/library/mysql:5.7.25 
- The following command should output "CentOS Linux":
    - docker run -it --rm centos:7 cat /etc/redhat-release
    - CentOS Linux release 7.6.1810 (Core) 
- A Quay.io account 
    - Register for a free account at https://quay.io/
    - Generate and retrieve your encrypted password from the Settings menu. We will be using it to interact with the Quay registry. 
- Note: With the above, you can perform all of the labs. 

