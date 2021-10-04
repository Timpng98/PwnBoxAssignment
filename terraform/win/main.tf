
# --- win/main.tf  --- #


resource "random_id" "tp_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}


resource "aws_key_pair" "tp_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "tp_node" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  ami                    = "ami-0b18ca1a93b538109"
  vpc_security_group_ids = [var.win_sg]
  subnet_id              = var.public_subnets[count.index]
  key_name               = aws_key_pair.tp_auth.id
  root_block_device {
    volume_size = var.vol_size
  }
  user_data = <<-EOF
<powershell>

$SiteFolderPath = "C:\WebSite"              # Website Folder
$SiteAppPool = "MyAppPool"                  # Application Pool Name
$SiteName = "MySite"                        # IIS Site Name
$SiteHostName = "www.MySite.com"            # Host Header

New-Item $SiteFolderPath -type Directory
Set-Content $SiteFolderPath\Default.htm "<h1>Hello IIS</h1>"
New-Item IIS:\AppPools\$SiteAppPool
New-Item IIS:\Sites\$SiteName -physicalPath $SiteFolderPath -bindings @{protocol="http";bindingInformation=":80:"+$SiteHostName}
Set-ItemProperty IIS:\Sites\$SiteName -name applicationPool -value $SiteAppPool

</powershell>
EOF

  tags = {
    Name = "win-${random_id.tp_node_id[count.index].dec}"
  }

}
