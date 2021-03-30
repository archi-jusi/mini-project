SHELL := /bin/bash
AWS_PROFILE := 56bit
STACKNAME := db-ec2-micro-project
REGION := eu-west-1
ACCOUNT := 489364105398
S3BUCKETLOG := bucket-${ACCOUNT}-${REGION}-db-ec2-micro-project
TEMPLATE_FILE := template-2-tier-app.yml
ENVIRONMENT := test
OWNER := jusi
CHANGESETNAME := db-ec2-micro-project-change-set
KEYPAIRNAME := db-ec2-micro-project-key-pair
InstanceTypeEC2 := t2.nano
SSHLocation := 0.0.0.0/0
AMIID := ami-0575fc648136871a1

deploy:
	make lint
	aws ec2 describe-key-pairs --key-name ${KEYPAIRNAME} || aws ec2 create-key-pair --key-name ${KEYPAIRNAME} --query "KeyMaterial" --output text > ${KEYPAIRNAME}.pem && chmod 400 ${KEYPAIRNAME}.pem
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --parameter-overrides KeyName=${KEYPAIRNAME} InstanceTypeEC2=${InstanceTypeEC2} SSHLocation="${SSHLocation}" DBUser="jusi" DBPassword="vrovrivnriudDZ" --tags environment=${ENVIRONMENT} owner=${OWNER}
	make output


clean:
	aws cloudformation delete-stack --stack-name ${STACKNAME}
	aws ec2 delete-key-pair --key-name ${KEYPAIRNAME}
	rm ${KEYPAIRNAME}.pem
	aws cloudformation describe-stacks --stack-name ${STACKNAME}

pre:
	aws ec2 describe-key-pairs --key-name ${KEYPAIRNAME} || aws ec2 create-key-pair --key-name ${KEYPAIRNAME} --query "KeyMaterial" --output text > ${KEYPAIRNAME}.pem && chmod 400 ${KEYPAIRNAME}.pem

plan:
	# LatestAmiId=${AMIID}
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --parameter-overrides KeyName=${KEYPAIRNAME} InstanceTypeEC2=${InstanceTypeEC2} SSHLocation="${SSHLocation}" --tags environment=${ENVIRONMENT} owner=${OWNER} --no-execute-changeset

destroy: 
	aws cloudformation delete-change-set --change-set-name ${CHANGESETNAME} \
    --stack-name ${STACKNAME}

apply:
	aws cloudformation execute-change-set --change-set-name ${CHANGESETNAME} \
    --stack-name ${STACKNAME} 

status:
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER} --no-execute-changeset

output:
	aws cloudformation describe-stacks --stack-name ${STACKNAME}  

trace: 
	make output
	make debug
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "DELETE_FAILED")'

error:
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "DELETE_FAILED")'
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'

lint:
	cfn-lint ${TEMPLATE_FILE}

install:
	@which jq || ( which brew && brew install jq || which apt-get && apt-get install jq || which yum && yum install jq || which choco && choco install jq)
	@which aws || pip3 install awscli || pip install awscli 
