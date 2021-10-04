# -- network/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.tp_vpc.id
}
output "public_sg" {
  value = aws_security_group.tp_sg["public"].id
}
output "public_subnets" {
  value = aws_subnet.tp_public_subnet.*.id
}
output "private_subnets" {
  value = aws_subnet.tp_private_subnet.*.id
}
output "juiceshop_sg" {
  value = aws_security_group.tp_sg["juiceshop"].id
}
output "win_sg" {
  value = aws_security_group.tp_sg["win"].id
}
output "linux_sg" {
  value = aws_security_group.tp_sg["linux"].id
}
