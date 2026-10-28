/* output "vpc_id_total" {
  value = aws_vpc.main
} */

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "eip" {
  value = aws_eip.nat_eip.id
}

output "public_rt" {
  value = aws_route_table.public_rt
}

output "private_rt" {
  value = aws_route_table.private_rt
}