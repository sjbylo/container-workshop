# Build & test the example application locally on your laptop  

In this lab you will download the source code of our example application and get it running on your laptop. 

_Don't worry if you can't complete this lab!!!!_

Note that it is anticipated that you may not succeed to install and run this application directly on your laptop!  
This is because you might not have Python installed, you might not have the correct version of python installed, you might have 
conflicting software install/running on your laptop etc etc etc... There are many issues that you
might face.   Later on we will see how Docker solves a lot of these problems by creating, running
and sharing our application in container images! 

If you have python, pip and git installed on your laptop you can complete this lab. 
To run the application on your laptop, first download the source code from GitHub. You can
download the source code from the command line like this or use whatever git software you are used to.

```
git clone https://github.com/ENTER_YOUR_GITHUB_USERNAME_HERE/flask-vote-app.git
```
`Ensure you have already forked the repository as described in the previous labs.`

If you see the error message "Repository not found", don't forget to replace ENTER_YOUR_GITHUB_USERNAME_HERE with your username!

If you still see the same error message, ensure you have forked the example application repository before you continue.

---
## Build and run the application

Change into the source code directory of the application.

```
cd flask-vote-app
```

The application is a simple voting application which collects answers to a simple question from users and displays the collected results. 

Have a look at the contents of the source code directory.  Note the following files/directories:
- *app.py*: contains the python source code of the application
- *requirements.txt*: contains the python dependencies that need to be installed for the application to work
- *seeds/seed_data.json*: contains the content of the voting application, the question that will be asked
- *templates*: contains the html templates that will be used to generate content for the browser

Note the application dependencies which are listed in the requirements file:

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

Open another terminal window and in that window test the application using curl.  

```
curl http://localhost:8080/ 
```

The curl command should output HTML containing "<title>Favorite Linux distribution</title>". 

Close the extra terminal window and `don't forget to quit the application using CTRL+C.`

**That's the end of the lab.**

Workshop contents: https://github.com/sjbylo/container-workshop

---

Optionally, you might like to try ...  testing the application by 'posting' come random votes using curl.

Post a few random votes to the application using:

```
for i in {1..20}
do
   echo Making vote nr. $i
   curl -s -X POST http://localhost:8080/vote.html -d "vote=`expr $(($RANDOM % 9)) + 1`" >/dev/null
done
```

To view the results use the following command. You should see the totals of all the categories:

```
curl -s http://localhost:8080/results.html | grep "data: \["
  data: [ "3",  "3",  "2",  "0",  "1",  "5",  "1",  "3",  "2", ],
```

