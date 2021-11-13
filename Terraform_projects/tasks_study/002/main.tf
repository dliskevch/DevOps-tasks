#---------------------------------------------------------
# My terraform_remote_state
#
# Build WebServer during bootstrap_action
#---------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "my-web-server" {
  ami                    = "ami-077e31c4939f6a2f3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-web-server.id]
  user_data              = <<-EOF
  #!/bin/bash
  yum -y update
  yum -y install httpd
  myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
  sudo service httpd start
  chkconfig httpd on
  EOF

  tags = {
    Name  = "WebServerBuildByTerraform"
    Owner = "DmytroLiskevych"
  }
}

resource "aws_security_group" "my-web-server" {
  name = "WebServerSecurityGroup"

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
    Name  = "SecurityGroupBuildByTerraform"
    Owner = "DmytroLiskevych"
  }
}
