# Optional. Configure the provider default tags 
provider "aws" {
  default_tags {
    tags = {
      Environment = "Test"
    }
  }
}

# Call the setup module to create a random bucket prefix
run "setup" {
  module {
    source = "./tests/setup"
  }
}

# Apply run block to create the bucket
run "create_bucket" {
  variables {
    bucket_name = "${run.setup.bucket_prefix}-aws-s3-website-test"
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == "${run.setup.bucket_prefix}-aws-s3-website-test"
    error_message = "Invalid bucket name"
  }

  # Check index.html hash matches
  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html"
  }

  # Check error.html hash matches
  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html"
  }
}