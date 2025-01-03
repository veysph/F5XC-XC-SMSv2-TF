variable "f5xc-ce-site-name" {
    description = "AWS CE site/cluster name"
    default = "pveys-smsv2-aws-tf"
}

variable "aws-ssh-key" {
    description = "AWS ssh key for the AMI"
    default = "pveys-eu-west-3"
}

variable "deployment-mode" {
    description = "How to deploy the F5XC CE: behind IGW or behind NAT-GW"
    default = "NAT-GW"
}

variable "aws-region" {
    description = "AWS region for F5XC CE deployment"
    default = "eu-west-3"
}