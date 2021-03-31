import json
import boto3
import datetime
import os

# get environment variable region
region = os.environ['AWS_REGION']


# transforn datetime type to string
def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def lambda_handler(event, context):
    print(event)
    
    ec2 = boto3.client('ec2', region)
    response = ec2.describe_instances()
    json_object = json.dumps(response, indent = 2,default = myconverter)
        
    return {
    	'statusCode': 200,
        'body': json_object
    }
        

