.PHONY: all deps dev

deps:
	npm install
all:
	npm run build

NAME:=qwerty-xincloud-io

.PHONY: setup teardown

setup:
	@echo "setup AWS cloudformation stack"
	aws cloudformation create-stack \
		--stack-name $(NAME) \
		--parameters ParameterKey=DomainName,ParameterValue=qwerty.xincloud.io \
					 ParameterKey=HostedZoneName,ParameterValue=xincloud.io. \
		--template-body file://$(PWD)/index.yaml

teardown:
	@echo "teardown AWS cloudformation stack"
	aws cloudformation delete-stack --stack-name $(NAME)
