# CloudWatch Alarms for Image Instances
resource "aws_cloudwatch_metric_alarm" "image_cpu_high" {
  alarm_name          = "image-cpu-util-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80  # Adjust as needed
  alarm_description   = "High CPU utilization for Image instances"
  alarm_actions       = [aws_autoscaling_policy.image_scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.image_asg.name
  }
}

resource "aws_autoscaling_policy" "image_scale_up" {
  name                   = "image-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.image_asg.name
}

# CloudWatch Alarms for Video Instances
resource "aws_cloudwatch_metric_alarm" "video_cpu_high" {
  alarm_name          = "video-cpu-util-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80  # Adjust as needed
  alarm_description   = "High CPU utilization for Video instances"
  alarm_actions       = [aws_autoscaling_policy.video_scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.video_asg.name
  }
}

resource "aws_autoscaling_policy" "video_scale_up" {
  name                   = "video-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.video_asg.name
}
