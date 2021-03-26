SHELL := /bin/bash
AWS_PROFILE := 56bit
STACKNAME := web-hosting-hello-world
S3BUCKET := jusi-micro-project
S3BUCKETLOG := bucket-489364105398-us-east-1-logging-webapp
TEMPLATE_FILE := website-helloworld.yml
ENVIRONMENT := test
OWNER := jusi


deploy:
	make lint
	aws cloudformation deploy --stack-name ${STACKNAME} --template-file ${TEMPLATE_FILE} --tags environment=${ENVIRONMENT} owner=${OWNER}
	aws cloudformation describe-stacks --stack-name ${STACKNAME}
	aws s3 sync ./ s3://${S3BUCKET} --exclude '*' --include "*.html"
	make output 

clean:
	aws s3 rm --recursive "s3://${S3BUCKET}" 
	aws s3 rm --recursive "s3://${S3BUCKETLOG}"
	aws cloudformation delete-stack --stack-name ${STACKNAME}
	aws cloudformation describe-stacks --stack-name ${STACKNAME}

output:
	aws cloudformation describe-stacks --stack-name ${STACKNAME}  | jq -r '.Stacks[].Outputs'

debug:
	aws cloudformation describe-stack-events --stack-name ${STACKNAME} | jq .

trace: 
	make output
	make debug
	aws cloudformation describe-stack-events --stack-name ${STACKNAME}  | jq '.StackEvents[] | select(.ResourceStatus == "CREATE_FAILED" )'

lint: 
	cfn-lint ${TEMPLATE_FILE}	
