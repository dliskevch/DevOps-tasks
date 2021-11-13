output "DNS_Entrypoint" {
  value = aws_instance.fnode.public_dns
}
output "Ansible_Public_IP" {
  value = aws_instance.ansible.public_ip
}
