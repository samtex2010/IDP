from flask import Flask, url_for
import boto3
import json
import os

app = Flask(__name__)

aws_region = os.getenv("AWS_REGION", "us-east-1")

ec2 = boto3.client('ec2', region_name=aws_region)

def ec2_get_regions(ec2):
    response = ec2.describe_regions()
    return response['Regions']

def ec2_get_azs(ec2):
    response = ec2.describe_availability_zones()
    return response['AvailabilityZones']

@app.route('/')
def hello_world():
    return 'Hello World\nVisit: {}\nVisit: {}'.format(url_for("regions"), url_for("azs"))

@app.route('/regions')
def regions():
    response = ec2_get_regions(ec2)
    return json.dumps(response)

@app.route('/azs')
def azs():
    response = ec2_get_azs(ec2) 
    return json.dumps(response)

if __name__ == '__main__':
    app.run()