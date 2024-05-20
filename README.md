# Learn Terraform - Test
* [Link](https://developer.hashicorp.com/terraform/tutorials/configuration-language/test)

## Goal
* Syntax for tests
* validate configuration -- via -- helper modules
* create mocks / -- avoid creating -- unnecessary resources

## Steps
* create S3 bucket
* upload files (/ host static website) there
* helper module -- to 
  * generate -- random bucket name
  * create -- `http` data source
  * publish to -- HCP Terraform private module registry

## Prerequisites
* Terraform [v1.7+](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed locally
* TODO:
