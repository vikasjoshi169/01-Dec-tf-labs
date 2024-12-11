provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0327f51db613d7bd2" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  key_name      = "my-key"                # Replace with your SSH key name

  tags = {
    Name = "LocalExecDemo"
  }

  provisioner "local-exec" {
    command = "ping -c 4 ${self.public_ip}"
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}