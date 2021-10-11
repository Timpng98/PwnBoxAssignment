# --- display's the private subnets to be able to ssh into each instance --- #

output "juiceshop_ip" {
  value = "ssh ec2-user@${module.juiceshop.juiceshop_ip}"
}
output "linux_ip" {
  value = "ssh ec2-user@${module.linux.linux_ip}"
}
output "win_ip" {
  value = module.win.win_ip
}
