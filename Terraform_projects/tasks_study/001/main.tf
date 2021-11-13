#---------------------------------------------------------
# My terraform_remote_state
#
# Build WebServerduring bootstrap_action
#---------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  count         = 2

  tags = {
    Name    = "MyUbuntuServer"
    Owner   = "DmytroLiskevych"
    Project = "TerraformStudy"
  }
}

resource "aws_instance" "my_amazon_linux" {
  ami           = "ami-077e31c4939f6a2f3"
  instance_type = "t2.micro"

  tags = {
    Name    = "MyAmazonServer"
    Owner   = "DmytroLiskevych"
    Project = "TerraformStudy"
  }
}
