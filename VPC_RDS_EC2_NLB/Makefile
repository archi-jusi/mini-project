SHELL := /bin/bash
AWS_PROFILE := 56bit
STACKNAME := vpc-ec2-micro-project
REGION := eu-west-2
ACCOUNT := 489364105398
TEMPLATE_FILE := Template_new_vpc_3_tier_app.yml
KEYPAIRNAME := test
ENVIRONMENT := test
OWNER := jusi
CHANGESETNAME := vpc-micro-project-change-set

deploy:
	make lint
	 aws --region ${REGION} ec2 describe-key-pairs --key-name ${KEYPAIRNAME} || (aws --region ${REGION} ec2 create-key-pair --key-name ${KEYPAIRNAME} --query "KeyMaterial" --output text > ${KEYPAIRNAME}.pem && chmod 400 ${KEYPAIRNAME}.pem)
	aws --region ${REGION} cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER} 
	make output


clean:
	aws --region ${REGION} cloudformation delete-stack --stack-name ${STACKNAME}
	aws --region ${REGION} ec2 delete-key-pair --key-name ${KEYPAIRNAME}
	rm ${KEYPAIRNAME}.pem
	aws --region ${REGION} cloudformation describe-stacks --stack-name ${STACKNAME}

pre:
	aws --region ${REGION} ec2 describe-key-pairs --key-name ${KEYPAIRNAME} || (aws --region ${REGION} ec2 create-key-pair --key-name ${KEYPAIRNAME} --query "KeyMaterial" --output text > ${KEYPAIRNAME}.pem && chmod 400 ${KEYPAIRNAME}.pem)

plan:
	# LatestAmiId=${AMIID}
	aws --region ${REGION} cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --parameter-overrides KeyName=${KEYPAIRNAME} InstanceTypeEC2=${InstanceTypeEC2} SSHLocation="${SSHLocation}" --tags environment=${ENVIRONMENT} owner=${OWNER} --no-execute-changeset

destroy: 
	aws --region ${REGION} cloudformation delete-change-set --change-set-name ${CHANGESETNAME} \
    --stack-name ${STACKNAME}

apply:
	aws --region ${REGION} cloudformation execute-change-set --change-set-name ${CHANGESETNAME} \
    --stack-name ${STACKNAME} 

status:
	aws --region ${REGION} cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER} --no-execute-changeset

output:
	aws --region ${REGION} cloudformation describe-stacks --stack-name ${STACKNAME}  

trace: 
	make output
	aws --region ${REGION} cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.'
	aws --region ${REGION} cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'
	aws --region ${REGION} cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "DELETE_FAILED")'

error:
	aws --region ${REGION} cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "DELETE_FAILED")'
	aws --region ${REGION} cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'

lint:
	cfn-lint ${TEMPLATE_FILE}

install:
	@which jq || ( which brew && brew install jq || which apt-get && apt-get install jq || which yum && yum install jq || which choco && choco install jq)
	@which aws --region ${REGION} || pip3 install aws --region ${REGION}cli || pip install aws --region ${REGION}cli 
