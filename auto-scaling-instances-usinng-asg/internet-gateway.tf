// internet-gateway for vpc and it public-subnets

resource "aws_internet_gateway" "igw-asg" {
   vpc_id = aws_vpc.asg-vpc.id

   tags = {
    Name = "igw-asg"
   }

}

// route table 

resource "aws_route_table" "rt-asg" {
    vpc_id = aws_vpc.asg-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-asg.id
    }
}

// route table association 

resource "aws_route_table_association" "rt-asg-assoc" {
    subnet_id = aws_subnet.public-subnet-asg-01.id
    route_table_id = aws_route_table.rt-asg.id
}

