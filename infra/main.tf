terraform {
  required_version = "~> 1.5.7" # to use BSD license

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Terraform = "true"
      Project   = "Apache Kafka with Java"
    }
  }
}

# an instance with new keypair
# assume that the account has a default VPC, subnets
locals {
  name = var.name
}

module "instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.5"

  name = local.name

  instance_type          = "t2.micro"
  key_name               = module.instance_key.key_pair_name
  vpc_security_group_ids = [module.instance_sg.security_group_id]
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# a SG for SSH within my IP
module "instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = local.name
  description = "Security group for ${local.name} practice"

  # TODO: 브로커(9092)와 주키퍼(2181)
  ingress_cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

module "instance_key" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name              = local.name
  create_private_key    = true
  private_key_algorithm = "ED25519"
}

resource "terraform_data" "private_key_pem" {
  triggers_replace = [
    module.instance_key.private_key_openssh,
  ]

  provisioner "local-exec" {
    command = <<EOT
      rm -f ${local.name}.pem
      echo '${module.instance_key.private_key_openssh}' > ${local.name}.pem
      chmod 400 ${local.name}.pem
    EOT
  }
}
