output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazon_linux_id" {
  value = data.aws_ami.latest_amazone_linux.id
}

output "latest_amazon_linux_name" {
  value = data.aws_ami.latest_amazone_linux.name
}

output "latest_windows_id" {
  value = data.aws_ami.latest_windows.id
}

output "latest_windows_name" {
  value = data.aws_ami.latest_windows.name
}
