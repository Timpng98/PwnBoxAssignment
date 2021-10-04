locals {
  vpc_cidr = "192.168.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security group for public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }

      }
    }
    juiceshop = {
      name        = "juiceshop_sg"
      description = "Security group for public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
        nginx = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
        juicesh = {
          from        = 3000
          to          = 3000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
        icmp = {
          from        = 0
          to          = 0
          protocol    = "-1"
          cidr_blocks = [local.vpc_cidr]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
    win = {
      name        = "win_sg"
      description = "Security group for public access"
      ingress = {
        rdp = {
          from        = 3389
          to          = 3389
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
      }
    }

    linux = {
      name        = "linux_sg"
      description = "Security group for public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
        telnet = {
          from        = 23
          to          = 23
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0", local.vpc_cidr]
        }
        nginx = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
        dns = {
          from        = 53
          to          = 53
          protocol    = "udp"
          cidr_blocks = [local.vpc_cidr]
        }
        ftp = {
          from        = 21
          to          = 21
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
        icmp = {
          from        = 0
          to          = 0
          protocol    = "-1"
          cidr_blocks = [local.vpc_cidr]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
        webwofl = {
          from        = 8080
          to          = 8080
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
        webgoat = {
          from        = 9090
          to          = 9090
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}
