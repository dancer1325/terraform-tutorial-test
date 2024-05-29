# Call the setup module to create a random bucket prefix
run "setup_tests" {
  #command  NOT specified -> apply by default
  # module specified -> run that module
  module {
    source = "./tests/setup"
  }
}

# Apply run block to create the bucket
run "create_bucket" {
  #command  NOT specified -> apply by default
  # module NOT specified -> apply the working directory module!!

  variables {
    # -- refer to -- another run block
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
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

# Plan run block to check the URL specified is accessible
run "website_is_running" {
  command = plan

  # NOT working directory module is executed
  module {
    source = "./tests/final"
  }

  variables {
    # refer to previous run
    endpoint = run.create_bucket.website_endpoint
  }

  assert {
    condition     = data.http.index.status_code == 200
    error_message = "Website responded with HTTP status ${data.http.index.status_code}"
  }
}


# For mocking tests
override_resource {
  target = aws_instance.backend_api
  # values NOT specified -> Terraform generates automatically, but with the criterias specified
}

override_resource {
  target = aws_db_instance.backend_api
  # values NOT specified -> Terraform generates automatically, but with the criterias specified
}

run "check_backend_api" {
  #command  NOT specified -> apply by default
  # module NOT specified -> apply the working directory module!!
  assert {
    condition     = aws_instance.backend_api.tags.Name == "backend"
    error_message = "Invalid name tag"
  }

  assert {
    condition     = aws_db_instance.backend_api.username == "foo"
    error_message = "Invalid database username"
  }
}