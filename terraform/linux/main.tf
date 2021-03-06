# --- compute/main.tf  --- #


resource "random_id" "tp_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

# --- creates the keys to be able to ssh into the instances --- #

resource "aws_key_pair" "tp_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# --- creates the instance for linux ubuntu --- #
resource "aws_instance" "tp_node" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  ami                    = "ami-087c17d1fe0178315"
  vpc_security_group_ids = [var.linux_sg]
  subnet_id              = var.public_subnets[count.index]
  key_name               = aws_key_pair.tp_auth.id
  user_data              = var.datafile
  root_block_device {
    volume_size = var.vol_size
  }
  tags = {
    Name = "linux-${random_id.tp_node_id[count.index].dec}"
  }


}
