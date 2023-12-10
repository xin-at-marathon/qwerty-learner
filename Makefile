.PHONY: all deps dev

deps:
	npm install
all:
	npm run dict
	npm run build

.PHONY: setup teardown
setup:
	aws_sam_template HttpsWebsite setup
teardown:
	aws_sam_template HttpsWebsite teardown


ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: deploy clean invalidate

S3_BUCKET_NAME:=$(shell aws_sam_get_stack_output_value $(STACK_NAME) S3BucketRoot)
deploy: clean invalidate
	@echo deploy to bucket: $(S3_BUCKET_NAME)
	aws s3 cp ./build s3://$(S3_BUCKET_NAME)/ --recursive

clean:
	@echo empty bucket: $(S3_BUCKET_NAME)
	aws s3 rm s3://$(S3_BUCKET_NAME) --recursive

CF_DISTRIBUTION_ID:=$(shell aws_sam_get_stack_output_value $(STACK_NAME) CFDistributionId)
invalidate:
	@echo invalidate CloudFront: $(CF_DISTRIBUTION_ID)
	aws cloudfront create-invalidation --no-cli-pager --distribution-id $(CF_DISTRIBUTION_ID) --paths '/*'
