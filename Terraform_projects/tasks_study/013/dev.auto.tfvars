# Auto Fill parameters for DEV

#File can be names as:
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars

region              = "ca-central-1"
instance_type       = "t3.micro"
detailed_monitoring = false

allow_ports = ["80", "443", "22", "8080"]

common_tag = {
  Owner       = "Dmytro_Liskevych"
  Project     = "GKZ"
  Environment = "Dev"
}
