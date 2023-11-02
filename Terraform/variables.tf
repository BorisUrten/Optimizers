variable "instance_type" {
  default = "t3.micro"
}

variable "environment" {
  default = "DevOps"
}

variable "ec2_key" {
  default = "MyKey"
}

variable "ec2_iam_instance_profile" {
  default = "DevOps-my_2023_ec2_profile"
}