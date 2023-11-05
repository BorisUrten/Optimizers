provider "aws" {
  alias = "vpc"
  region     = "us-east-1"
  access_key = Your_Access_key
  secret_key = Your_Secret_key
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-01eccbf80522b562b"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
  subnet_id              = module.vpc.public_subnet1_id  # Use the correct output variable name

  # ... other configurations

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    echo "<h1>Apache is up and running!</h1>" | sudo tee /var/www/html/index.html
    # Add more user data commands here as needed
    EOF

  tags = {
    Name = "public_instance"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}

resource "aws_instance" "public_instance_2" {
  ami                    = "ami-01eccbf80522b562b"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
  subnet_id              = module.vpc.public_subnet2_id  # Use the correct output variable name

  # ... other configurations
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    echo "<h1>Apache is up and running!</h1>" | sudo tee /var/www/html/index.html
    # Add more user data commands here as needed
    EOF

  tags = {
    Name = "public_instance_2"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}