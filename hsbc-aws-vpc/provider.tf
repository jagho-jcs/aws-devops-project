# Setup our AWS Provider..!

provider "aws" {
  version = "~> 2.22.0"

  shared_credentials_file = "/../../.aws/credentials"
  profile                 = "dev-jcs"
  region                  = "${var.aws_region}"
}



# # Setup our AWS Provider..!

# provider "aws" {
#   version = "~> 2.7"

#   shared_credentials_file = "/../../.aws/credentials"
#   profile                 = "dev-jcs"
#   region                  = "${var.aws_region}"
# }