# Build & test the example application locally on your laptop  

In this lab you will download the source code of our example application and get it running on your laptop. 

_Don't worry if you can't complete this lab!!!!_

Note that it is anticipated that you may not succceed to install and run this app directly on your laptop!  This is because you might not have Python installed, you might not have the correct version, you might have conflicting software install/running on your laptop etc etc etc...

If you have python, pip and git installed on your laptop you can complete this lab. 
To run the app on your laptop, first download the source code from Github. You can
download the source code from the command line like this or use whatever git software you are used to.

```
git clone https://github.com/YOUR_GITHUB_USERNAME/flask-vote-app.git
```
Especially if you see the error message "Repository not found", don't forget to replace YOUR_GITHUB_USERNAME with your username!

If you still see the same error message, ensure you have forked the example app repository before you continue.

---
Change into the source code directory of the app.

```
cd flask-vote-app
```

The app is a simple voting app which collects answers to a simple question from users and displays the collected results. 

Have a look at the contents of the source code directory.  Note the following file/directories:
- app.py: contains the python source code of the application
- requirements.txt: contains the python dependencies that need to be installed for the app to work
- seeds/seed_data.json: contains the content of the coting app, the question that will be asked
- templates: contains the html templates that will be used to generate content for the browser

Note the app dependencies which are listed in the requirements file:

```
cat requirements.txt
```

Install the dependencies from the requirements file:

```
pip install -r requirements.txt
```

Run and test the application.

```
python app.py
...
Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
```

You should see the python application starting up and then listening on port 8080.

Open a browser and try out the application to see how it works. Notice you can only make ONE vote (since a cookie is used to remember you have voted).

Open another terminal window and in that window test the app using curl.  

```
curl http://localhost:8080/ 
```

The curl command should output HTML which should contain "<title>Favorite Linux distribution</title>". 

Close the extra termianl window and quit the app using CTRL+C.

**The is the end of the lab**

FIEME - want this?! Might break the code!
If you are interested, you might like to try to make a simple change in the code, rebuild and test the application.  if the app is working, commit the code change to Github.


