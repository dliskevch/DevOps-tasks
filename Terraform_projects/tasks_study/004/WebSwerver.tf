#---------------------------------------------------------
# My terraform_remote_state
#
# Build WebServerduring bootstrap_action
#----------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-077e31c4939f6a2f3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Dmytro",
    l_name = "Liskevych",
    names  = ["Vasya", "Anton", "Dima", "Vika"]
  })

  tags = {
    Name  = "Web Server build by Terraform"
    Owner = "Dmytro Liskevych"
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Dmytro Liskevych"
  }
}
