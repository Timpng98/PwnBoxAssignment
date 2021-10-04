output "win_ip" {
  value = aws_instance.tp_node[0].public_dns
}

