provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "web_server" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "Hello from Terraform EC2" > /var/www/html/index.html
              EOF
  tags = {
    Name = "terraform_ec2"
  }
}

resource "aws_security_group" "web_sg" {
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}