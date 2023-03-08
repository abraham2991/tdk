# Define the EC2 instance configuration
resource "aws_instance" "example" {
  ami           = "ami-0b029b1931b347543" # replace with your desired AMI ID
  instance_type = "t3.micro"
  key_name      = "${var.key_pair_name}" # replace with your SSH key name

  # Associate the instance with the VPC and subnet
  vpc_security_group_ids = [aws_security_group.aws_assignment_sg.id]
  subnet_id              = aws_subnet.aws_assignment_subnet_1.id

}

resource "aws_eip" "example" {
  instance = aws_instance.example.id

  tags = {
    Name = "example-eip"
  }
}