# Auto Fill parameters for PROD

#File can be names as:
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars
# *.auto.tfvars

region              = "us-east-2"
instance_type       = "t2.micro"
detailed_monitoring = true

allow_ports = ["80", "443", "8080"]

common_tag = {
  Owner       = "SoftServe"
  Project     = "Study"
  Environment = "Prod"
}
