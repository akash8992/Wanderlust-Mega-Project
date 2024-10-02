provider "aws" {
  region = "ap-south-1" # Change to your desired region
}

# IAM User
resource "aws_iam_user" "demo_iam" {
  name = "demo-iam"
}

# IAM User Access Key
resource "aws_iam_access_key" "demo_iam_access_key" {
  user = aws_iam_user.demo_iam.name
}

# Key Pair
resource "aws_key_pair" "demo_keypair" {
  key_name   = "demo-keypair"
  public_key = file("~/.ssh/id_rsa.pub") # Change this to your public key path
}

# Security Group
resource "aws_security_group" "demo_security_group" {
  name        = "demo-securityGroup"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to a more restrictive CIDR block if necessary
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "demo_instance" {
  ami           = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.large"
  key_name      = aws_key_pair.demo_keypair.key_name

  root_block_device {
    volume_size = 30 # Size in GB
    volume_type = "gp2" # General Purpose SSD
  }

  vpc_security_group_ids = [aws_security_group.demo_security_group.id]

  tags = {
    Name = "DemoInstance"
  }
}
