// security group acts as firewall to the instance 

resource "aws_security_group" "asg-sg" {
    name = "security-group for asg"
    description = " allow all egress traffic and ssh traffic "
    vpc_id = aws_vpc.asg-vpc.id

    egress {

        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all egress traffic"
        protocol = -1 
        from_port = 0
        to_port = 0
        security_groups = []
        prefix_list_ids = []
        self = false
        ipv6_cidr_blocks = ["::/0"]
 
    }

    ingress {

        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh allowed"
        protocol = "tcp"
        from_port = 22
        to_port = 22
        security_groups = []
        prefix_list_ids = []
        self = false
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "allow-ssh"
    }
}