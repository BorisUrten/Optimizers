# Define Application Load Balancer
resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [aws_subnet.public1.id, aws_subnet.public2.id] # Update with your subnet IDs
  enable_deletion_protection = false
  enable_http2 = true
  enable_cross_zone_load_balancing = true
}

# Define Target Groups for images and videos
resource "aws_lb_target_group" "images" {
  name        = "images-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id = aws_vpc.default.id # Update with your VPC ID
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "videos" {
  name        = "videos-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id = aws_vpc.default.id # Update with your VPC ID
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attach Target Groups to instances
resource "aws_lb_target_group_attachment" "images-attachment" {
  target_group_arn = aws_lb_target_group.images.arn
  target_id        = aws_instance.public_instance.id
}

resource "aws_lb_target_group_attachment" "videos-attachment" {
  target_group_arn = aws_lb_target_group.videos.arn
  target_id        = aws_instance.public_instance_2.id
}

# Create the Application Load Balancer listener with default action
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

# Create path-based routing rules for the listener
resource "aws_lb_listener_rule" "itmeme_rule" {
  listener_arn = aws_lb_listener.example.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.images.arn
  }

  condition {
    path_pattern {
      values = ["/itmeme/*"]
    }
  }
}

resource "aws_lb_listener_rule" "video_rule" {
  listener_arn = aws_lb_listener.example.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.videos.arn
  }

  condition {
    path_pattern {
      values = ["/video/*"]
    }
  }
}



