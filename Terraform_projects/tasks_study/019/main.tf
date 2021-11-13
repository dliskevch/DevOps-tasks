#----------------------------------------------------------
# My Terraform
#
# Provision Resources in Multiply AWS Regions / Accounts
#----------------------------------------------------------

provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "USA"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "GER"
}

#==========================================================

data "aws_ami" "defaut_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "ger_latest_ubuntu" {
  provider    = aws.GER
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

#=================================================================

resource "aws_instance" "my_default_server" {
  ami           = data.aws_ami.defaut_latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "my_USA_server" {
  provider      = aws.USA
  ami           = data.aws_ami.usa_latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "USA Server"
  }
}

resource "aws_instance" "my_GER_server" {
  provider      = aws.GER
  ami           = data.aws_ami.ger_latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "GER Server"
  }
}
