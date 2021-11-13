#---------------------------------------------------------
# My terraform_remote_state
#
# Work with lifecycles. Create E_IP
#----------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = {
    Name  = "Web Server IP"
    Owner = "Dmytro Liskevych"
  }
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-077e31c4939f6a2f3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Dmytro",
    l_name = "Liskevych",
    names  = ["Vasya", "Anton", "Dima", "Vika", "Katya", "Vlad", "Tom"]
  })

  tags = {
    Name  = "Web Server build by Terraform"
    Owner = "Dmytro Liskevych"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My SecurityGroup for test WebServer"

  dynamic "ingress" {
    for_each = ["80", "443"]
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
    Name  = "Web Server SecurityGroup"
    Owner = "Dmytro_Liskevych"
  }
}
