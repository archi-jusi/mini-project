SHELL := /bin/bash
AWS_PROFILE := 56bit
STACKNAME := web-hosting-hello-world
REGION := eu-west-3
S3BUCKET := static-web-hello-world-micro-project
S3BUCKETLOG := bucket-${ACCOUNT}-${REGION}-logging-webapp
TEMPLATE_FILE := website-helloworld.yml
ENVIRONMENT := test
OWNER := jusi

deploy:
	make lint
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER}
	aws cloudformation describe-stacks --stack-name ${STACKNAME}
	make sync

sync:
	aws s3 sync ./ s3://${S3BUCKET} --exclude '*' --include "*.html"

clean:
	aws s3 rm --recursive "s3://${S3BUCKET}" 
	aws s3 rm --recursive "s3://${S3BUCKETLOG}"
	aws cloudformation delete-stack --stack-name ${STACKNAME}
	aws cloudformation describe-stacks --stack-name ${STACKNAME}

plan:
	 aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER} --no-execute-changeset

output:
	aws cloudformation describe-stacks --stack-name ${STACKNAME}
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}



error:
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "DELETE_FAILED")'
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED")'

lint:
	cfn-lint ${TEMPLATE_FILE}
	aws cloudformation validate-template --template-body file://${TEMPLATE_FILE}

install:
	@which jq || ( which brew && brew install jq || which apt-get && apt-get install jq || which yum && yum install jq || which choco && choco install jq)
	@which aws || pip3 install awscli || pip install awscli 
