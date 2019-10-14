# Setup our AWS Provider..!

provider "aws" {
  version = "~> 2.22.0"

  shared_credentials_file = "/../../.aws/credentials"
  profile                 = "dev-jcs"
  region                  = "${var.region}"
}