provider "aws" {
  region = "sa-east-1"
}


resource "aws_instance" "maquina_master" {
  ami           = "ami-054a31f1b3bf90920"
  instance_type = "t2.medium"
  key_name      = "dev-lucgabm-tf"
  associate_public_ip_address = true
  subnet_id = "subnet-0ce8b292e31b2d588"
  vpc_security_group_ids = ["${aws_security_group.acessos_master.id}"]
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "k8s_master_pf"
  }
}

resource "aws_security_group" "acessos_master" {
  name        = "maquina_master"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id = "vpc-0a63c3c39a1c7f9ac"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_master_single_master"
  }
}

output "Security_groups" {
  value = [
    "Sg Master ${aws_security_group.acessos_master.id}",
  ]
}

output "Master" {
  value = [
    "Master ${aws_instance.maquina_master.public_ip}",
    "Img ${aws_instance.maquina_master.id}",
    "ssh  ubuntu@${aws_instance.maquina_master.public_dns}"
  ]
}