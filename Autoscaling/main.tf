provider "aws" {
   region = var.region
   access_key = var.access_key
   secret_key = var.secret_key
}

resource "aws_launch_configuration" "asg-lc" {
    name_prefix = "terraform-lc-01"
    image_id = var.ami
    instance_type = var.instance_type

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg-01" {

     name = "asg-01-terraform"
     launch_configuration = aws_launch_configuration.asg-lc.name
     min_size = 1
     max_size = 3
     desired_capacity = 1
     health_check_grace_period = 30
     health_check_type = "EC2"
     force_delete = true
     termination_policies = ["OldestInstance"]
     vpc_zone_identifier = [aws_subnet.public-subnet-01.id, aws_subnet.public-subnet-02.id]
     

     lifecycle {
       create_before_destroy = true
     }
}

resource "aws_autoscaling_policy" "asg-01-pol" {
    name = "autoscalingpolicy"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = 2
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.asg-01.name
     
}

// cloud watch metric alarm for asg

resource "aws_cloudwatch_metric_alarm" "alarm-asg" {
    alarm_name = "asg-alarm-01"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    period = "30"
    namespace = "AWS/EC2"
    statistic =  "Average"
    threshold = "10"
    alarm_actions = [
        "${aws_autoscaling_policy.asg-01-pol.arn}"
    ]
    dimensions = {
        AutoScalingGroupName = "${aws_autoscaling_group.asg-01.name}"
    } 
}

resource "aws_vpc" "asg-vpc" {
    cidr_block = var.cidr_vpc
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "asg-vpc"
    }
}

resource "aws_subnet" "public-subnet-01" {
    vpc_id = aws_vpc.asg-vpc.id
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"
    tags = {
        Name = "public-subnet-01"

    }
}

resource "aws_subnet" "public-subnet-02" {
    vpc_id = aws_vpc.asg-vpc.id
    cidr_block = var.subnet_cidr-02
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1b"
    tags = {
        Name = "public-subnet-02"
        
    }
}