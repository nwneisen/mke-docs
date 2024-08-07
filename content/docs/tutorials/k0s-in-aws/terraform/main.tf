terraform {
  required_version = ">= 0.14.3"
}

provider "aws" {
  region = var.region
}

resource "tls_private_key" "k0sctl" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cluster-key" {
  key_name   = format("%s_key", var.cluster_name)
  public_key = tls_private_key.k0sctl.public_key_openssh
}

// Save the private key to filesystem
resource "local_file" "aws_private_pem" {
  file_permission = "600"
  filename        = format("%s/%s", path.module, "aws_private.pem")
  content         = tls_private_key.k0sctl.private_key_pem
}

resource "aws_security_group" "cluster_allow_ssh" {
  name        = format("%s-allow-ssh", var.cluster_name)
  description = "Allow ssh inbound traffic"
  // vpc_id      = aws_vpc.cluster-vpc.id

  // Allow all incoming and outgoing ports.
  // TODO: need to create a more restrictive policy
  ingress {
    description = "SSH from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-allow-ssh", var.cluster_name)
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


locals {
  k0s_tmpl = {
    metadata = {
      name = var.cluster_name
    }
    spec = {
      kubernetes = {
        config = {
          spec = {
            network = {
              provider : "custom"
            }
          }
        }
        infra = {
          hosts = [
            for host in concat(aws_instance.cluster-controller, aws_instance.cluster-workers) : {
              ssh = {
                address = host.public_ip
                user    = "ubuntu"
                keyPath = local_file.aws_private_pem.filename
                port    = 22
              }
              role = host.tags["Name"]
            }
          ]
        }
      }
      components = {
        addons = []
      }
    }
  }
}

output "k0s_cluster" {
  value = yamlencode(local.k0s_tmpl)
}

output "lb_dns_name" {
    value = aws_lb.lb.dns_name
}
