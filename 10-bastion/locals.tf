locals {

  public_subnet_ids = split(
    ",",
    data.aws_ssm_parameter.public_subnet_ids.value
  )

  public_subnet_id = local.public_subnet_ids[0]

  vpc_id = data.aws_ssm_parameter.vpc_id.value

  my_ip = "${chomp(data.http.my_public_ip.response_body)}/32"

  private_subnet_ids = split(
    ",",
    data.aws_ssm_parameter.private_subnet_ids.value
  )

  private_subnet_id = local.private_subnet_ids[0]

}