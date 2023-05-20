
// auto-scaling-policy for auto-scaling-group

resource "aws_autoscaling_policy" "cpu-policy" {
    name = "auto-scaling-policy-cpu-utilization"
    autoscaling_group_name = aws_autoscaling_group.asg-dev-env.name // on basis of asg this policy will trigger
    adjustment_type = "ChangeInCapacity"  // when change in capacity increase instance 
    scaling_adjustment = "1" // increase one instance when cpu utilization is increased
    cooldown = "300" // cooldown period
    policy_type = "SimpleScaling" // type of scaling 
}


// cloud watch alarm to trigger the notification when cpu utilization is greater tham threshold value

resource "aws_cloudwatch_metric_alarm" "alarm-01" {
    alarm_name = "alarm to trigger"
    comparison_operator = "GreaterThanOrEqualToThreshold" // greater than threshold 
    evaluation_periods = "2"
    metric_name = "CPUUtilization" // metric name like cpu utilization
    namespace = "AWS/EC2"
    statistic = "Average"
    threshold = "30"  // threshold value 
    period = "60"
   
   dimensions = {
    "AutoScalingGroupName"= aws_autoscaling_group.asg-dev-env.name
   }

   actions_enabled = true
   alarm_actions = [aws_autoscaling_policy.cpu-policy.arn]   

}

//  policy to scale down 
resource "aws_autoscaling_policy" "scale-down" {
    name =  "scale down the instances"
    autoscaling_group_name = aws_autoscaling_group.asg-dev-env.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "-1"  // when threshold reaches to minimum it will drop down the instances
    cooldown = "300"
    policy_type = "SimpleScaling"
    
}

// cloud watch alarm to scale down 

resource "aws_cloudwatch_metric_alarm" "scale-down-alarm" {
   alarm_name = "scale down alarm"
   comparison_operator = "GreaterThanOrEqualToThreshold"  // when threshold reaches to its value it will scale down
   evaluation_periods = "2"
   metric_name = "CPUUtilization" // based on cpu utilization
   namespace = "AWS/EC2"  // in which namespace 
   statistic = "Average"  
   threshold = "10" // threshold value 
   period = "60" // takes 60 sec to create or drop down the instance

   dimensions = {
     "AutoScalingGroupName" = aws_autoscaling_group.asg-dev-env.name
   }

   actions_enabled = true
   alarm_actions = [aws_autoscaling_policy.cpu-policy.arn]

}