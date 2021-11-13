data "aws_ami" "amazon_latest_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsLzJTKRyTn9FqQe2SyBUqN6dFFhQWK0g8xJmcVZrlLsHgjGdBB9JZVs6HOUdXbSPPPFNDtwoStYjZ0tSAlf/do7oHvWM6QdldwL9UsiMik64MlqIZk+6++RmJuB7czQPf9tzeVBFaW0mvo08BdfTC5DZqIoJAcXptY0L/XbAduXbib+NNuSNSVYVAAVsED8dCGEVJrRHCfVOeyBZMS7s/i7ufA+JqW60voPpp1kNE8IQIRUFMQjRzamx1SlAwta6idnN6lW9hj1MhS50b+697QrAlgq/4fPY/v85ekTbbkSeGiYeiok/6vvB0iFbHiD6gTBpMYihZpdJEXVxZKCYv traefik"
}

resource "aws_instance" "docker1" {
  ami                    = data.aws_ami.amazon_latest_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.dcrtv.id]
  private_ip             = "10.0.1.31"
  monitoring             = var.detailed_monitoring
  key_name               = aws_key_pair.deployer.id
  user_data              = file("user_data_docker.sh")

  tags = merge(var.common_tag, { Name = var.name_server1 })
}

resource "aws_instance" "docker2" {
  ami                    = data.aws_ami.amazon_latest_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.dcrtv.id]
  private_ip             = "10.0.1.32"
  monitoring             = var.detailed_monitoring
  key_name               = aws_key_pair.deployer.id
  user_data              = file("user_data_docker.sh")

  tags = merge(var.common_tag, { Name = var.name_server2 })
}

resource "aws_instance" "ansible" {
  ami                    = data.aws_ami.amazon_latest_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.dcrtv.id]
  private_ip             = "10.0.1.30"
  monitoring             = var.detailed_monitoring
  key_name               = aws_key_pair.deployer.id
  user_data              = file("user_data_ansible.sh")

  tags = merge(var.common_tag, { Name = var.name_server3 })
}
