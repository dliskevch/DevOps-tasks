#------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#------------------------------------------

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "user1" {
  name = "Dmytro"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#----------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}
