#----------------------------------------------------------
# My Terraform
#
# Terrafor Conditions and Lookups
#----------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

// Use of Condition
resource "aws_instance" "my_webserver1" {
  ami = "ami-00399ec92321828f5"
  # instance_type = var.env == "prod" ? "t2.large" : "t2.micro"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : "t2.micro"

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}

// Use of LOOKUP
resource "aws_instance" "my_webserver2" {
  ami           = "ami-00399ec92321828f5"
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}

// Create Bastion ONLY for if "dev" environment
resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"

  tags = {
    Name = "Bastion Server for Dev-Server"
  }
}


resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Dmytro_Liskevych"
  }
}
