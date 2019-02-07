
# Build & test the app locally on your laptop  

This part of the labs is optional.  If you have python, pip and git installed on your laptop, you can complete this part. 
To run the app on your laptop, first download the source code from Git Hub. You can run git from the command line like this.

```
git clone https://github.com/sjbylo/flask-vote-app.git
```

Change into the source code directory of the app .

```
cd flask-vote-app
```
Install the dependencies which are listed in the requirements file.

```
pip install -r requirements.txt

```

Run and test the application.

```
python app.py
...
curl http://localhost:8080/ 
```

The curl command should output HTML which should contain "<title>Favourite Linux distribution</title>". 
If you don't have curl, open the URL in a broswer.


