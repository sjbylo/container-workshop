# Build & test the application locally on your laptop  

In this lab you will download the source code of our workshop application and get it running on your laptop. 

If you have python, pip and git installed on your laptop, you can complete this part. 
To run the app on your laptop, first download the source code from Git Hub. You can
download the source code from the command line like this.

```
git clone https://github.com/sjbylo/flask-vote-app.git
```

Change into the source code directory of the app.

```
cd flask-vote-app
```

Have a look at the contents of the source code directory.  See .... FIXME

Install the dependencies which are listed in the requirements file.

```
pip install -r requirements.txt

```

Run and test the application.

```
python app.py
<output from the app...>
```

You should see the python application starting up and then listening. 

Open another terminal window and in that window test the app using curl.  Or, if you don't have curl, use a normal browser and try out the application. 

```
curl http://localhost:8080/ 
```

The curl command should output HTML which should contain "<title>Favorite Linux distribution</title>". 

