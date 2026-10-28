output "bastion_ec2" {
  value = aws_instance.bastion.id
}

output "private_ec2" {
  value = aws_instance.private_ec2.id
}