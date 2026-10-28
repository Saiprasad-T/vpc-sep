data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/vpc/public_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc/id"
}

data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/vpc/private_subnet_ids"
}