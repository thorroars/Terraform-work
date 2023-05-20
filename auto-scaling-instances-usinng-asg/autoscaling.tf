   
// basic launch configuration to be launched to auto-scale the instances 
// launch configuration acts as basic core to launch a configuration

resource "aws_launch_configuration" "lc-01" {

  name_prefix = "launch-configuration for auto-scaling-group"
  image_id = var.ami  // this image id will be represented to create an instance 
  instance_type = var.instance_type // instance type 
  security_groups = [aws_security_group.asg-sg.id] // security groups for instance 
  

}

// auto-scaling-group to autoscale the instances
resource "aws_autoscaling_group" "asg-dev-env" {
    name = "auto-scaling-group-for-dev-environment"
    launch_configuration = aws_launch_configuration.lc-01.name //based on launch configuration it will auto-scale
    vpc_zone_identifier = [aws_subnet.public-subnet-asg-01.id, aws_subnet.public-subnet-asg-02.id] // in which network it will be placed like subnets ,vpc 
    min_size = 1  // minimum number of instances
    max_size = 3  // maximum number of instances 
    desired_capacity = 1  // desired capacity 
    health_check_grace_period = 300  // health check period
    health_check_type = "EC2"  // on which basis healthcheck will be happen ?
    force_delete = true

    tag {
        key = "name"
        value = "ec2-instance"
        propagate_at_launch = true

    }
}