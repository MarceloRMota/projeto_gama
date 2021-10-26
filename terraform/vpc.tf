resource "aws_vpc" "vpc_projeto_final" {
  cidr_block = "10.5.0.0/16"
  tags = {
    Name = "vpc_projeto_final"
  }
}

resource "aws_subnet" "my_subnet_a" {
  vpc_id            = aws_vpc.vpc_projeto_final.id
  cidr_block        = "10.5.1.0/24"
  availability_zone = "sa-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "subnet_projeto_final_a"
  }
}

resource "aws_subnet" "my_subnet_b" {
  vpc_id            = aws_vpc.vpc_projeto_final.id
  cidr_block        = "10.5.2.0/24"
  availability_zone = "sa-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_projeto_final_b"
  }
}

resource "aws_subnet" "my_subnet_c" {
  vpc_id            = aws_vpc.vpc_projeto_final.id
  cidr_block        = "10.5.3.0/24"
  availability_zone = "sa-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_projeto_final_c"
  }
}

resource "aws_subnet" "my_subnet_d" {
  vpc_id            = aws_vpc.vpc_projeto_final.id
  cidr_block        = "10.5.4.0/24"
  availability_zone = "sa-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_projeto_final_d"
  }
}

output "VPC_e-Subnets" {
  value = [
    "VPC ID ${aws_vpc.vpc_projeto_final.id}",
     "Subnet Pub ${aws_subnet.my_subnet_c.id}",
     "Subnet Pub ${aws_subnet.my_subnet_b.id}",
     "Subnet Pub ${aws_subnet.my_subnet_d.id}",
     "Subnet Priv ${aws_subnet.my_subnet_a.id}",
  ]
}