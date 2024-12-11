
#remote_exec provisioner new code

provider "aws" {
  region = "ap-south-1" 								# Specify your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0327f51db613d7bd2" 				# Amazon Linux 2 AMI ID (check for the latest in your region)
  instance_type = "t2.micro"

  key_name = "terraform-demo" 							# Replace with your key pair name

  security_groups = ["AllowAllTraffic"] 						# Replace with your security group name

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/terraform-demo.pem") 	# Replace with your private key path
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Terraform-Example"
  }
}

resource "aws_security_group" "http-sg" {
  name        = "http-sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
