provider "aws" {
  # Use a relative path to refer to the provider configuration file
  shared_credentials_files = ["C:/Users/Kevin/.aws/credentials" ]
  shared_config_files = ["C:/Users/Kevin/.aws/config"]
  region = "us-east-2"
}