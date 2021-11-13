#----------------------------
# My Terraform
#
# Local variables
#----------------------------

provider "aws" {
  region = "us-east-2"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
  country           = "Ukraine"
  city              = "Kyiv"
  az_list           = join(", ", data.aws_availability_zones.available.names)
  region            = data.aws_region.current.description
  location          = "In ${local.region} there are AZ: ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {
  tags = {
    Name          = "Static IP"
    Owner         = var.owner
    Project       = local.full_project_name
    Project_owner = local.project_owner
    district      = "${local.city} in ${local.country}"
    region_azs    = local.az_list
    location      = local.location
  }
}
