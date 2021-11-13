variable "region" {
  default     = "us-east-2"
  type        = string
  description = "AWS Region to deploy Server"
}

variable "common_tag" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "Vitalii Storozh"
    Project     = "Phoenix"
    Environment = "Development"
  }
}

variable "name_server" {
  default     = "Web Server build by Terraform"
  type        = string
  description = "Name for servers"
}

variable "name_static_ip" {
  default     = "Server IP"
  type        = string
  description = "Name for static ip for servers"
}

variable "name_security_group" {
  default     = "Server Security Group"
  type        = string
  description = "Name for security group"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "Instance type"
}

variable "allow_ports" {
  default     = ["80", "443", "22", "8080"]
  type        = list(any)
  description = "Lists of port to servers"
}

variable "detailed_monitoring" {
  default     = false
  type        = bool
  description = "Enable monitoring"
}
