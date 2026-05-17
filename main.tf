provider "aws" {
  region = "ap-south-1"
}
provider "aws" {
    alias = "south"
  region = "ap-south-2"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"] #

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"] 
  }
}
data "aws_ami" "amazon_linux_2023_south" {
  provider = aws.south
  most_recent = true
  owners      = ["amazon"] #

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"] 
  }
}
resource "aws_instance" "ap-south-1" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  tags = {
    Name = "ap-south-1-Linux-Server"
  }
}
resource "aws_instance" "ap-south-2" {
  provider = aws.south
  ami           = data.aws_ami.amazon_linux_2023_south.id
  instance_type = "t3.micro"
  tags = {
    Name = "ap-south-2-Linux-Server"
  }
}   
