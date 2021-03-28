import json
import boto3
import datetime

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def lambda_handler(event, context):
    # TODO implement
    print(event)
    
    if event['region']:
        region = event['region']
        ec2 = boto3.client('ec2', region)
        response = ec2.describe_instances()
        json_object = json.dumps(response, indent = 2,default = myconverter)
        
        return {
        'statusCode': 200,
        'body': json_object
        }
        
    else:
        ec2 = boto3.client('ec2')
        response = ec2.describe_instances()
        
        json_object = json.dumps(response, indent = 2,default = myconverter)
        
        return {
            'statusCode': 200,
            'body': json_object

        }

