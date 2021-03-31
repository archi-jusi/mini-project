# Mini-Project - General requirements

-  The below technical requirements need to be implemented using Infrastructure as Code. 
-  Cloudformation, Python and/or Bash scripting

## Project 1:

### Description

Host a simple "Hello World" HTML page. This page should be fronted by an AWS Cloudfront distribution.

### Explanation:

The static web site is hosted on S3. 
The bucket is encrypted using SS3 and versioned.

The user can connect to the website only from the cloudfront URL and not directly on the bucket using Origin Access Identity (OAI).

There is another bucket which is logging all the requests from the cloudfront.

The bucket is encrypted and versioned.

Use of GNU MakeFile and aws CLI to deploy/debug/destroy faster, to pass the password securely and not put in file, you can use environment variable or variable as a parameter during the command (Don't forget to indent the command as it will not be written in your bash_history ).

Before deploying, I'm using cfn-lint to check cloudformation syntax, you can use this command to install what you need:

```bash
make install
```

Note: I'm using the MakeFile on MacOs, everything will work on Linux but you will need to make few change in case of windows.

A Password is written in the MakeFile **only** for testing purpose.

```bash
 make deploy DBPASSWORD="dejkvreukvberviue"
make plan
make clean -i 
```

e.g. for make deploy

```bash

deploy:
	make lint
	aws ec2 describe-key-pairs --key-name ${KEYPAIRNAME} || (aws ec2 create-key-pair --key-name ${KEYPAIRNAME} --query "KeyMaterial" --output text > ${KEYPAIRNAME}.pem && chmod 400 ${KEYPAIRNAME}.pem)
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --parameter-overrides KeyName=${KEYPAIRNAME} InstanceTypeEC2=${InstanceTypeEC2} SSHLocation="${SSHLocation}" DBUser="jusi" DBPassword=${DBPASSWORD} --tags environment=${ENVIRONMENT} owner=${OWNER}
	make output

lint:
	cfn-lint ${TEMPLATE_FILE}

output:
	aws cloudformation describe-stacks --stack-name ${STACKNAME}

```



The SSH Key pair is created using AWS CLI in the MakeFile process as below:

```bash

deploy

aws ec2 describe-key-pairs --key-name ${KEYPAIRNAME} || (aws ec2 create-key-pair --key-name ${KEYPAIRNAME} --query "KeyMaterial" --output text > ${KEYPAIRNAME}.pem && chmod 400 ${KEYPAIRNAME}.pem)
```


## Project 2:

Host a simple API, using any technology you wish. The API should return a list of EC2 instances in the region of your choice by querying the EC2 API, when doing a GET request through Postman. No authentication or authorization is required (i.e. can be open to the public Internet). Kindly forward the URL to us.

### Explanation

Everything is deployed using SAM (AWS Serverless Application Model) which is basically an extension of Cloudformation.

Sam is really awesome! All the explanation is in a README.md in the associate directory for this project (lambda_api).

To get the list of EC2 instance in the current region, I'm using Lambda and Python. We can use jq to parse the json.

The SAM Template will create a changeset and deploy: 

- AWS::Lambda::Permission
- AWS::Lambda::Function
- AWS::IAM::Role
- AWS::ApiGateway::Deployment
- AWS::ApiGateway::Stage
- AWS::ApiGateway::RestApi

### Project 3 & Project 4

Create a small Relational Database Service MySQL instance and database.

* Create a server with the following specifications:
    * OS: Amazon Linux 2 -> Using Parameter Store native variable
    * Accessible: Through SSH to the public from all IPs (no security). Kindly forward the URL and any SSH authentication keys/files for us to access it. OK
    * Lowest CPU / RAM you can find OK
    * Update the server using the latest security patches  —> OK
    * Create a file called test.txt with the value 97LEDKYGOF6C56Q4GYR. This file should be created in the OS root (/) OK
    * Connect to the database created above and create a table called "CandidateTest". Kindly forward the RDS master password to us.

Explanation:

I've decided to put the project 3 and 4 in the same Cloudformation Template as it's like a 2-tier project and they are working together.

The Database can use a Multi-AZ and a replica DB optionally.
As the EC2 instance is like a bastion or Jumphost to manage the Database, I didn't make an ASG and a NLB. 

The DataBase port (3306) is opened only from the security group of the EC2 instance.

If using a NLB and we want it redundant, it will increase the cost quite a lot so I've decided to make a tradeoff in term of redundancy in favor of cost. This will be different of course follow each case.

If there is any issue with the EC2 instance, it will be very fast to deployed a new one using the cloudformation template.

On each solution, there is always a tradeoff to do between performance, security, cost and redundancy, and time and complexity to implement. 

I had to decide between redundancy and autoscaling for EC2 and security and cost for all the solution but not only, time to implement and documentation was as well in the balance, I've decided to go for the second one as security should go always first in my opinion.

The EC2 instance will use parameter store to get the latest AMI Amazon Linux 2 in the region where it will be deployed.


Improvement if more time to experiment: 

- for the password of the DB -> Use of Secret Manager for rotation password
  - I've tested with Parameter Store and it was working well for the DB but didn't manage to make it work and get the information from the EC2
-  
















