terraform {
  backend "s3" {
    bucket = "ar-live-tf-us-east-1"
    key    = "alice-test/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  instance_name = "alice-test"

  alice_ami  = "ami-0016be2ad9424c8cb"
  alice_type = "t2.micro"

  key_name        = "dft-ar-live-keypair"
  country         = "ar"
  env             = "live"
  ops_vpc_cidr    = "10.11.0.0/16"
  bastionops_cidr = "10.11.1.224/32"
  magallanes_cidr = "10.11.11.230/32"

  service-name = "dft-ar-nv-alice"

  general_tags = {
    DFT_COUNTRY  = local.country
    DFT_ENV      = local.env
    cost_company = "dft"
    cost_country = local.country
    cost_env     = local.env
    company      = "dft"
    cost_company = "dft"
    terraform    = "true"
    role         = "web"
    group        = "ssc"
    env          = local.env
    country      = local.country
  }


}

data "aws_vpc" "live" {
  id = "vpc-00cd7730a28de3fd7"
}

data "aws_subnet" "private_a" {
  id = "subnet-0059287cb911fe844"
}

data "aws_security_group" "alice" {
  id = "sg-0f5263203075ab081"
}
