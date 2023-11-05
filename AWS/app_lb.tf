# Create Launch Configuration for Image Instances
resource "aws_launch_configuration" "image_launch_config" {
  name_prefix          = "image-launch-config-"
  image_id             = aws_ami.public_instance_ami.id   # Replace with your desired AMI ID
  instance_type        = "t2.micro"  # Replace with your desired instance type
  security_groups      = [aws_security_group.sg_ec2.id]
  key_name             = aws_key_pair.key_pair.key_name

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

# Create Launch Configuration for Video Instances
resource "aws_launch_configuration" "video_launch_config" {
  name_prefix          = "video-launch-config-"
  image_id             = aws_ami.public_instance_2_ami.id  # Replace with your desired AMI ID
  instance_type        = "t2.micro"  # Replace with your desired instance type
  security_groups      = [aws_security_group.sg_ec2.id]
  key_name             = aws_key_pair.key_pair.key_name

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}


# Create Auto Scaling Group for Image Instances
resource "aws_autoscaling_group" "image_asg" {
  name_prefix                  = "image-asg-"
  launch_configuration         = aws_launch_configuration.image_launch_config.name
  vpc_zone_identifier          = [aws_subnet.public1.id, aws_subnet.public2.id]
  min_size                     = 1
  max_size                     = 5
  desired_capacity             = 1
  target_group_arns            = [aws_lb_target_group.images.arn]
  health_check_type            = "EC2"
  health_check_grace_period    = 300
  default_cooldown             = 300
  termination_policies         = ["OldestLaunchConfiguration"]  
}

# Create Auto Scaling Group for Video Instances
resource "aws_autoscaling_group" "video_asg" {
  name_prefix                  = "video-asg-"
  launch_configuration         = aws_launch_configuration.video_launch_config.name
  vpc_zone_identifier          = [aws_subnet.public1.id, aws_subnet.public2.id]
  min_size                     = 1
  max_size                     = 5
  desired_capacity             = 1
  target_group_arns            = [aws_lb_target_group.videos.arn]
  health_check_type            = "EC2"
  health_check_grace_period    = 300
  default_cooldown             = 300
  termination_policies         = ["OldestLaunchConfiguration"]
}


