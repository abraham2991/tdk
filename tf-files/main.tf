# Define the provider (in this case, AWS)




# # Delete the default VPC
# resource "aws_default_vpc" "default_vpc" {
#   provider = aws.default
#   force_destroy = true
# }

# Create the VPC
resource "aws_vpc" "assignment_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "${var.infra_name}-vpc"
  }
}
resource "aws_subnet" "aws_assignment_subnet_1" {
  vpc_id            = aws_vpc.assignment_vpc.id
  cidr_block        = "${var.subnet1_cidr}"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.infra_name}-subnet_1"
  }
}

resource "aws_subnet" "aws_assignment_subnet_2" {
  vpc_id            = aws_vpc.assignment_vpc.id
  cidr_block        = "${var.subnet2_cidr}"
  availability_zone = "us-west-2b"
  tags = {
    Name = "${var.infra_name}-subnet_2"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "aws_assignment_igw" {
  vpc_id = aws_vpc.assignment_vpc.id
  tags = {
    Name = "${var.infra_name}-igw"
  }
}

# Create a new security group
resource "aws_security_group" "aws_assignment_sg" {
  name_prefix = "${var.infra_name}-sg"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.assignment_vpc.id
  tags = {
    Name = "${var.infra_name}-sg"
  }
}
# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.assignment_vpc.id

  tags = {
    Name = "${var.infra_name}-publicroute"
  }
}
# Route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.aws_assignment_subnet_1.id
  route_table_id = aws_route_table.public.id
}
# Add default route to internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.aws_assignment_igw.id
}

# Add a rule allowing egress to the internet
resource "aws_security_group_rule" "aws_assignment_sg_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_assignment_sg.id
}

