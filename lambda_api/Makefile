SHELL := /bin/bash
AWS_PROFILE := 56bit
STACKNAME := vpc-micro-project
REGION := eu-west-3
ACCOUNT := 489364105398
S3BUCKET := jusi-micro-project
S3BUCKETLOG := bucket-${ACCOUNT}-${REGION}-logging-webapp
TEMPLATE_FILE := micro-project-vpc.yml
ENVIRONMENT := test
OWNER := jusi
CHANGESETNAME := webapp-change-set

deploy:
	make lint
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER}
	aws cloudformation describe-stacks --stack-name ${STACKNAME}
	make output 

sync:
	aws s3 sync ./ s3://${S3BUCKET} --exclude '*' --include "*.html"

clean:
	aws s3 rm --recursive "s3://${S3BUCKET}" 
	aws s3 rm --recursive "s3://${S3BUCKETLOG}"
	 ${STACKNAME}
	aws cloudformation describe-stacks --stack-name ${STACKNAME}

plan:
	 aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER} --no-execute-changeset

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

debug:
	aws cloudformation describe-stack-events --stack-name ${STACKNAME} | jq .

trace: 
	make output
	make debug
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'

error:
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "DELETE_FAILED")'
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'

lint:
	cfn-lint ${TEMPLATE_FILE}

install:
	@which jq || ( which brew && brew install jq || which apt-get && apt-get install jq || which yum && yum install jq || which choco && choco install jq)
	@which aws || pip3 install awscli || pip install awscli 
