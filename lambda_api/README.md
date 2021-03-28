Requirement:
Install SAM - Serverless Application Model
https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html

For testing purpose:

```bash
sam init -r python3.8 -d pip --app-template hello-world -n test-python-sam
```

To deploy:

```bash
sam deploy --guided

Configuring SAM deploy
======================

	Looking for config file [samconfig.toml] :  Not found

	Setting default arguments for 'sam deploy'
	=========================================
	Stack Name [sam-app]: ListingEC2-API-Lambda-Test
	AWS Region [eu-west-3]:
	#Shows you resources changes to be deployed and require a 'Y' to initiate deploy
	Confirm changes before deploy [y/N]: y
	#SAM needs permission to be able to create roles to connect to the resources in your template
	Allow SAM CLI IAM role creation [Y/n]: Y
	FunctionListingEC2 may not have authorization defined, Is this okay? [y/N]: y
	Save arguments to configuration file [Y/n]: Y
	SAM configuration file [samconfig.toml]: ListingEC2-API-Lambda-Test-config.toml
	SAM configuration environment [default]: 56bit
```

After you set all the arguments, Sam will create a Changeset to show the resource which will be create (dry-run) and you can validate or not the creation.

```
Initiating deployment
=====================
FunctionListingEC2 may not have authorization defined.
Uploading to ListingEC2-API-Lambda-Test/9e850f8fdd080cd168a5b79f562224ae.template  1644 / 1644  (100.00%)

Waiting for changeset to be created..

CloudFormation stack changeset
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Operation                                   LogicalResourceId                           ResourceType                                Replacement
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+ Add                                       FunctionListingEC2ListEC2ApiPermissionPro   AWS::Lambda::Permission                     N/A
                                            d
+ Add                                       FunctionListingEC2Role                      AWS::IAM::Role                              N/A
+ Add                                       FunctionListingEC2                          AWS::Lambda::Function                       N/A
+ Add                                       PermissionListingEC2Role                    AWS::Lambda::Permission                     N/A
+ Add                                       ServerlessRestApiDeployment4d3c41e0d9       AWS::ApiGateway::Deployment                 N/A
+ Add                                       ServerlessRestApiProdStage                  AWS::ApiGateway::Stage                      N/A
+ Add                                       ServerlessRestApi                           AWS::ApiGateway::RestApi                    N/A
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Changeset created successfully. arn:aws:cloudformation:eu-west-3:489364105398:changeSet/samcli-deploy1616948497/a554bc7e-dba7-4c63-8334-c5709d58c835


Previewing CloudFormation changeset before deployment
======================================================
Deploy this changeset? [y/N]: y

2021-03-28 18:22:20 - Waiting for stack create/update to complete

CloudFormation events from changeset
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ResourceStatus                              ResourceType                                LogicalResourceId                           ResourceStatusReason
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE_IN_PROGRESS                          AWS::IAM::Role                              FunctionListingEC2Role                      Resource creation Initiated
CREATE_IN_PROGRESS                          AWS::IAM::Role                              FunctionListingEC2Role                      -
CREATE_COMPLETE                             AWS::IAM::Role                              FunctionListingEC2Role                      -
CREATE_IN_PROGRESS                          AWS::Lambda::Function                       FunctionListingEC2                          Resource creation Initiated
CREATE_IN_PROGRESS                          AWS::Lambda::Function                       FunctionListingEC2                          -
CREATE_COMPLETE                             AWS::Lambda::Function                       FunctionListingEC2                          -
CREATE_IN_PROGRESS                          AWS::ApiGateway::RestApi                    ServerlessRestApi                           Resource creation Initiated
CREATE_IN_PROGRESS                          AWS::Lambda::Permission                     PermissionListingEC2Role                    Resource creation Initiated
CREATE_IN_PROGRESS                          AWS::Lambda::Permission                     PermissionListingEC2Role                    -
CREATE_IN_PROGRESS                          AWS::ApiGateway::RestApi                    ServerlessRestApi                           -
CREATE_COMPLETE                             AWS::ApiGateway::RestApi                    ServerlessRestApi                           -
CREATE_IN_PROGRESS                          AWS::Lambda::Permission                     FunctionListingEC2ListEC2ApiPermissionPro   Resource creation Initiated
                                                                                        d
CREATE_IN_PROGRESS                          AWS::ApiGateway::Deployment                 ServerlessRestApiDeployment4d3c41e0d9       -
CREATE_IN_PROGRESS                          AWS::Lambda::Permission                     FunctionListingEC2ListEC2ApiPermissionPro   -
                                                                                        d
CREATE_COMPLETE                             AWS::ApiGateway::Deployment                 ServerlessRestApiDeployment4d3c41e0d9       -
CREATE_IN_PROGRESS                          AWS::ApiGateway::Deployment                 ServerlessRestApiDeployment4d3c41e0d9       Resource creation Initiated
CREATE_IN_PROGRESS                          AWS::ApiGateway::Stage                      ServerlessRestApiProdStage                  -
CREATE_IN_PROGRESS                          AWS::ApiGateway::Stage                      ServerlessRestApiProdStage                  Resource creation Initiated
CREATE_COMPLETE                             AWS::ApiGateway::Stage                      ServerlessRestApiProdStage                  -
CREATE_COMPLETE                             AWS::Lambda::Permission                     PermissionListingEC2Role                    -
CREATE_COMPLETE                             AWS::Lambda::Permission                     FunctionListingEC2ListEC2ApiPermissionPro   -
                                                                                        d
CREATE_COMPLETE                             AWS::CloudFormation::Stack                  ListingEC2-API-Lambda-Test                  -
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CloudFormation outputs from deployed stack
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Outputs
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Key                 ListingEC2FunctionIamRole
Description         Implicit IAM Role created for EC2 Lambda function
Value               ListingEC2-API-Lambda-Test-PermissionListingEC2Role-165XMTRDME137

Key                 ListingEC2Function
Description         Listing EC2 Lambda Function ARN
Value               arn:aws:lambda:eu-west-3:489364105398:function:ListingEC2-API-Lambda-Test-FunctionListingEC2-XYL1KV32C546

Key                 ListingEC2Api
Description         API Gateway endpoint URL for Prod stage for Ec2 listing function
Value               https://jrlitgtkj3.execute-api.eu-west-3.amazonaws.com/Prod/listec2/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Successfully created/updated stack - ListingEC2-API-Lambda-Test in eu-west-3

```



The command will output the configuration in config file with the toml extension that you can use later as below: 

sam deploy --config-file listingec2_56bit.toml


To validate configuration and template:

sam validate -t template.yml --config-file listingec2_56bit.toml

To work faster and test directly from Visual Studio Code

https://docs.aws.amazon.com/toolkit-for-vscode/latest/userguide/setup-toolkit.html

To test via browser or directly from curl:

curl -X GET https://kout4d7jmh.execute-api.eu-west-3.amazonaws.com/Prod/listec2

To make it cleaner if you have jq installed

curl -X GET https://kout4d7jmh.execute-api.eu-west-3.amazonaws.com/Prod/listec2 | jq '.'

#verbose
curl -v https://kout4d7jmh.execute-api.eu-west-3.amazonaws.com/Prod/listec2

Checking Post not working:

curl -X POST https://kout4d7jmh.execute-api.eu-west-3.amazonaws.com/Prod/listec2 
{"message":"Missing Authentication Token"}%

To delete you will need to do from the GUI or from CLI to delete the cloudformation stack created before by SAM:

```bash
aws cloudformation delete-stack --stack-name ListingEC2-API-Lambda-Test
```
