// public subnets for vpc's 

resource "aws_subnet" "public-subnet-asg-01" {
    vpc_id = aws_vpc.asg-vpc.id
    cidr_block = var.subnet_cidr_01
    map_public_ip_on_launch = true
    availability_zone = var.az-01

    tags = {
        Name = "Public-subnet-asg"
        ENvironment = "Dev"
    }
}


resource "aws_subnet" "public-subnet-asg-02" {
    vpc_id = aws_vpc.asg-vpc.id
    cidr_block = var.subnet_cidr_02
    map_public_ip_on_launch = true
    availability_zone = var.az-02

    tags = {
        Name = "Public-subnet-asg-02"
        ENvironment = "Dev"
    }
}