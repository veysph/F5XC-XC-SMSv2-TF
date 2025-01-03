terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider for region and auth
provider "aws" {
  region                   = var.aws-region
  shared_config_files      = ["/Users/p.veys/.aws/config"]
  shared_credentials_files = ["/Users/p.veys/.aws/credentials"]
  profile                  = "default"
}

#Set subnet F5XC CE
#If subnet is tagged with:
#f5xc-ce-deployment IGW, then public ip address will be allocated to the AMI and the CE will be deployed in the tagged subnet
#f5xc-ce-deployment NAT-GW, then no public ip address will be allocated to the AMI and the CE will be deployed in the tagged subnet
#AWS NAT-GW and IGW components must be configured and functional for the selected subnets before executing the terrafom
data "aws_subnet" "smsv2-subnet" {
  filter {
    name   = "tag:f5xc-ce-deployment"
    values = [var.deployment-mode]
  }
}

#Set the security group based on the tag
data "aws_security_group" "f5xc-ce-sg" {
  filter {
    name = "tag:Internal-VPC-SG"
    values = ["true"]
  }
}

#Set the cloud-init config file for F5XC CE
data "cloudinit_config" "f5xc-ce_config" {
  gzip          = false
  base64_encode = false
  part {
    filename = "f5xc-ce-cloudconfig.yaml"
    content_type = "text/cloud-config"
    content = file("${path.module}/f5xc-ce-cloudconfig.yaml")
  }
}

#Create the F5XC CE
resource "aws_instance" "smsv2-aws-tf" {
  ami                         = "ami-05f8f42b21a455447"
  instance_type               = "t3.xlarge"
  associate_public_ip_address = var.deployment-mode == "NAT-GW" ? "false" : "true"
  key_name                    = var.aws-ssh-key
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 80
  }
  subnet_id = data.aws_subnet.smsv2-subnet.id
  vpc_security_group_ids = [data.aws_security_group.f5xc-ce-sg.id]

  user_data = data.cloudinit_config.f5xc-ce_config.rendered

  tags = {
    Name                                         = var.f5xc-ce-site-name
    ves-io-site-name                             = var.f5xc-ce-site-name
    "kubernetes.io/cluster/${var.f5xc-ce-site-name}"   = "owned"
  }
}