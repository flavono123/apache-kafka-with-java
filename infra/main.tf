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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "tag:Name"
    values = ["default-public-subnet-1"]
  }
}

module "instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.5"

  name = local.name

  instance_type               = "t2.micro"
  key_name                    = module.instance_key.key_pair_name
  vpc_security_group_ids      = [module.instance_sg.security_group_id]
  subnet_id                   = data.aws_subnets.default_public.ids[0]
  associate_public_ip_address = true

  user_data = <<EOT
    #!/bin/bash
    # Install Java
    sudo yum install -y java-1.8.0-openjdk-devel
    java -version
  EOT
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

  # HACK: 브로커(9092)와 주키퍼(2181) source cidr all이어야 동작함. 왜?
  ingress_cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  ingress_rules = [
    "ssh-tcp",
  ]
  ingress_with_cidr_blocks = [
    {
      rule        = "kafka-broker-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "zookeeper-2181-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]


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

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${local.name}.pem")
    host        = module.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Download Kafka
      "wget https://archive.apache.org/dist/kafka/2.5.0/kafka_2.12-2.5.0.tgz",
      "tar -xzf kafka_2.12-2.5.0.tgz",
      "cd kafka_2.12-2.5.0",
      "export KAFKA_HEAP_OPTS='-Xmx400M -Xms400M'",
      "echo \"export KAFKA_HEAP_OPTS='-Xmx400M -Xms400M'\" >> ~/.bashrc",
      # Start Zookeeper
      "bin/zookeeper-server-start.sh -daemon config/zookeeper.properties",
      # Set Kafka config
      "export PUBLIC_IP=$(curl -q http://checkip.amazonaws.com/)",
      "sed -i \"s%#advertised.listeners=PLAINTEXT://your.host.name:9092%advertised.listeners=PLAINTEXT://$PUBLIC_IP:9092%g\" config/server.properties",
      # Start Kafka
      "bin/kafka-server-start.sh -daemon config/server.properties",
      # HACK: last line seems to be ignored, so add a dummy line; X -> there should be another reason. this line excuted every time.
      "echo 'done'",
    ]
  }
}
