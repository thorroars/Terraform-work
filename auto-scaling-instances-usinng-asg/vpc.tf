// vpc network for auto-scaling-group

resource "aws_vpc" "asg-vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "asg-vpc"
        Environment = "Dev"
    }
}