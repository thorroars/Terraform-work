provider "aws" {
   region = "ap-south-1"
   access_key = "AKIAV3VJCXUUQLZC6OWL"
   secret_key = "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"
}

resource "aws_lb" "app-lb" {
  name = "application-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [aws_subnet.alb-public-subnet.id, aws_subnet.alb-public-subnet-1b.id]
  security_groups = [aws_security_group.alb-sg.id]
  enable_deletion_protection = false

  tags = {
    Name = "alb-tf"
    Environment = "Dev"
  }

}

resource "aws_vpc" "alb-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "alb-vpc"
  }
}

resource "aws_subnet" "alb-public-subnet" {
    vpc_id = aws_vpc.alb-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"

    tags = {
        Name = "alb-public-subnet"
    }
  
}

resource "aws_subnet" "alb-public-subnet-1b" {
    vpc_id = aws_vpc.alb-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1b"

    tags = {
        Name = "alb-public-subnet"
    }
  
}

resource "aws_internet_gateway" "alb-igw" {
    vpc_id = aws_vpc.alb-vpc.id

    tags = {
        Name = "igw-alb"
    }
}

resource "aws_route_table" "alb-rt" {
  vpc_id = aws_vpc.alb-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.alb-igw.id
  }
}

resource "aws_route_table_association" "alb-rt-assoc" {
    subnet_id = aws_subnet.alb-public-subnet.id
    route_table_id = aws_route_table.alb-rt.id
}

resource "aws_security_group" "alb-sg" {
    name = "security-group for alb"
    vpc_id = aws_vpc.alb-vpc.id

    egress {

        description = ""
        cidr_blocks = ["0.0.0.0/0"]
        protocol = -1
        from_port = 0
        to_port = 0
        prefix_list_ids = []
        security_groups = []
        self = false
        ipv6_cidr_blocks = ["::/0"]

    }

    ingress {

        description = "http-allowed"
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = 80
        to_port = 80
        prefix_list_ids = []
        security_groups = []
        self = false
        ipv6_cidr_blocks = ["::/0"]

    }

}

resource "aws_lb_target_group" "alb-tg" {
    name = "orders-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.alb-vpc.id
    depends_on = [ aws_vpc.alb-vpc ]
    target_type = "instance"

    health_check {
       path = "/orders/index.html" 
       port = 80
       healthy_threshold = 5
       unhealthy_threshold = 2
       timeout = 5
       interval = 30
       matcher = "200"
    }

    tags = {
        Name = "orders-target-group"
    }
}

resource "aws_lb_target_group_attachment" "orders-tg-instance" {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    target_id = aws_instance.orders-instance.id
    port = 80
  
}

resource "aws_lb_target_group" "alb-tg-payments" {
    name = "payments-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.alb-vpc.id
    depends_on = [ aws_vpc.alb-vpc ]

    tags = {
        Name = "payments-target-group"
    }
}

resource "aws_lb_target_group_attachment" "payments-tg-instance" {
    target_group_arn = aws_lb_target_group.alb-tg-payments.arn
    target_id = aws_instance.payments-instance.id
    port = 80
}

resource "aws_lb_target_group" "alb-tg-bookings" {
    name = "bookings-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.alb-vpc.id
    depends_on = [ aws_vpc.alb-vpc ]

    tags = {
        Name = "bookings-target-group"
    }
}

resource "aws_lb_target_group_attachment" "bookings-tg-instance" {
    target_group_arn = aws_lb_target_group.alb-tg-bookings.arn
    target_id = aws_instance.bookings-instance.id
    port = 80
  
}
resource "aws_lb_listener" "orders-listners" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_instance" "orders-instance" {
     ami = "ami-022d03f649d12a49d"
     instance_type = "t2.micro"
     vpc_security_group_ids = ["${aws_security_group.alb-sg.id}"]
     subnet_id = aws_subnet.alb-public-subnet.id
     user_data = <<EOF

     #! /bin/bash
     yum install httpd -y
     service httpd start
     chkconfig httpd on
     mkdir /var/www/html/orders
     echo " hello this is orders page " > /var/www/html/orders/index.html

     EOF

     tags = {
        Name = "Orders-servers"
        Environment = "Dev"
     }
}

resource "aws_instance" "payments-instance" {
    ami = "ami-022d03f649d12a49d"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.alb-sg.id}"]
    subnet_id = aws_subnet.alb-public-subnet.id
    user_data = <<EOF

     #! /bin/bash
     yum install httpd -y
     service httpd start
     chkconfig httpd on
     mkdir /var/www/html/payments
     echo " hello this is payments page " > /var/www/html/payments/index.html

     EOF

     tags = {
        Name = "Payments-Servers"
        Environment = "Dev"
     }
  
}

resource "aws_instance" "bookings-instance" {
    ami = "ami-022d03f649d12a49d"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.alb-sg.id}"]
    subnet_id = aws_subnet.alb-public-subnet.id
    user_data = <<EOF

     #! /bin/bash
     yum install httpd -y
     service httpd start
     chkconfig httpd on
     mkdir /var/www/html/bookings
     echo " hello this is bookings page " > /var/www/html/bookings/index.html

     EOF

     tags = {
        Name = "bookings-Servers"
        Environment = "Dev"
     }
  
}