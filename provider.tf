# Configure the AWS Provider
provider "aws" {
  region = var.regions["east"]
  shared_credentials_files = ["C:/Users/Kevin/.aws/credentials" ]
  shared_config_files = ["C:/Users/Kevin/.aws/config"]
}