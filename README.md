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
* AWS account with [associated credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)
  * via
    * add in the 'provider' block
    * environment variables
      * 'AWS_ACCESS_KEY_ID'
      * 'AWS_SECRET_ACCESS_KEY'
      * 'AWS_REGION'
    * credential files
      * `aws config` & pass the 'AWS_ACCESS_KEY_ID' & 'AWS_SECRET_ACCESS_KEY'

## Structure
* 'www/'
  * simple HTML files with simple tetris application
* '*.tftest.hcl'
  * Terraform test files
* '/tests'
  * default folder in which `terraform test` looks for the test files
  * '/setup/main.tf'
    * helper module to set up the skeleton -- that's why it's executed in the first `run` --
* Check 'configurationLanguage/Tests' to understand the syntax

## How to execute tests?
* `terraform init`
* `terraform test`
  * Check that resources are created in AWS
  * Problems:
    * Problem1: "validating provider credentials: retrieving caller identity from STS: operation error STS: GetCallerIdentity"
      * Attempts1: Add 'provider.profile' & 'provider.shared_credentials_files'
      * Attempt2: Switch to another region
      * Solution: Adjust aws.version & `terraform init -upgrade`
    * Problem2: "tests/website.tftest.hcl... tearing down" forever
      * Attempt1: `terraform force-unlock`
      * Attempt2: `terraform refresh`
      * Solution: Eliminate manually in the AWS console
    * Problem3: " timeout error: GET"
      * Solution: Upgrade 'http.version' & `terraform init -upgrade`

## Publish to organization's HCP Terraform registry
* TODO:

## Mock tests
* Check 'main.tf' & 'website.tftest.hcl', to the specific sections