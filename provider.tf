provider "aws" {
  shared_config_files = [ "config" ]
  shared_credentials_files = [ "creds" ]
  profile = "default"
}