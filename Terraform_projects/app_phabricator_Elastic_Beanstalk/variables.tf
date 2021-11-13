variable "region" {
  default = "us-east-2"
}
variable "name" {
  default = "dima-beanstalk-env"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "autoscale_min" {
  default = 2
}

variable "autoscale_max" {
  default = 2
}

variable "db_settings" {
  default = {
    db_user = "admin"
    db_password = "adminphabr756"
  }
  sensitive = true
}