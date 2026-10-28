locals {
  public_subnet_ids = aws_subnet.public[*].id
}