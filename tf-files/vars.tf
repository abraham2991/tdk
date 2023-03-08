variable "infra_name" {
  type = string
  default = "abraham"
}


variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "my_ip" {
  type = string
  default = "98.198.181.229"
}

variable "key_pair_name" {
  type = string
  default = "abraham-ec2keys"
}