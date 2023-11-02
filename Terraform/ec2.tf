resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.my_subnet.id
  key_name               = var.ec2_key
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  iam_instance_profile = var.ec2_iam_instance_profile

  tags = {
    Name = "MyEC2Instance"
  }

  user_data = <<-EOF
                	  #!/bin/bash
      sudo yum update -y
	    sudo yum install -y httpd
	    sudo systemctl start httpd.service
	    # sudo systemctl enable httpd.service
	    sudo echo "<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Sample Deployment</title>
  <style>
    body {
      color: #ffffff;
      background-color: #0188cc;
      font-family: Arial, sans-serif;
      font-size: 14px;
    }
    
    h1 {
      font-size: 500%;
      font-weight: normal;
      margin-bottom: 0;
    }
    
    h2 {
      font-size: 200%;
      font-weight: normal;
      margin-bottom: 0;
    }
  </style>
</head>
<body>
  <div align="center">
    <h1>Congratulations-ZIYOTEK DevOps Class</h1>
    <h2>This application was deployed using Jenkins.</h2>
    <h3>Next Step is starting a new career.</h3>
    <p>For next steps, read the <a href="http://aws.amazon.com/documentation/codedeploy">AWS CodeDeploy Documentation</a>.</p>
  </div>
</body>
</html>" > /var/www/html/index.html
              EOF
  # user_data                   = file("/var/www/html/index.html")
  associate_public_ip_address = true
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
}