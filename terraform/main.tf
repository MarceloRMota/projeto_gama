provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "k8s_proxy" {
  ami           = "ami-0498cb2b9c855bb43"
  instance_type = "t2.micro"
  subnet_id     = "subnet-039f8bb8424a2adf0"
  key_name      = "jenkins_key"
  tags = {
    Name = "k8s-haproxy"
  }
    root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  vpc_security_group_ids = [aws_security_group.k8s_acessos_master_pf.id]
}

resource "aws_instance" "k8s_masters" {
  ami           = "ami-0498cb2b9c855bb43"
  instance_type = "t2.large"
  key_name      = "jenkins_key"
  subnet_id     = "subnet-039f8bb8424a2adf0"
  count         = 3
  
  tags = {
    Name = "k8s-master-${count.index}"
  }
    root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  vpc_security_group_ids = [aws_security_group.k8s_acessos_master_pf.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_workers" {
  ami           = "ami-0498cb2b9c855bb43"
  instance_type = "t2.medium"
  subnet_id     = "subnet-0ce8b292e31b2d588"
  key_name      = "jenkins_key"
  count         = 2
  
  tags = {
    Name = "k8s_workers-${count.index}"
  }
  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  vpc_security_group_ids = [aws_security_group.k8s_acesso_workers_pf.id]
}

resource "aws_instance" "k8s_private_workers" {
  ami           = "ami-0498cb2b9c855bb43"
  instance_type = "t2.medium"
  subnet_id     = "subnet-0ba351a68949c6953"
  key_name      = "jenkins_key"
  tags = {
    Name = "k8s_workers-priv01"
  }
  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  vpc_security_group_ids = [aws_security_group.k8s_acesso_workers_pf.id]
}

resource "aws_security_group" "k8s_acessos_master_pf" {
  name        = "k8s_acessos_master_pf"
  description = "acessos inbound traffic"
  vpc_id = "vpc-0a63c3c39a1c7f9ac"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = "Libera acesso k8s_masters"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = true
      to_port          = 0
    },
    # {
    #   cidr_blocks      = []
    #   description      = "Libera acesso k8s_workers"
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     "sg-091ca0091e6ddea12",
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
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
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "k8s_acesso_workers_pf" {
  name        = "k8s_acesso_workers_pf"
  description = "acessos inbound traffic"
  vpc_id = "vpc-0a63c3c39a1c7f9ac"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    # {
    #   cidr_blocks      = []
    #   description      = ""
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     aws_security_group.acessos_master.id,
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]
  tags = {
    Name = "allow_ssh"
  }
}

output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+1} - ${item.private_ip} - ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i ~/.ssh/id_rsa ubuntu@${item.public_dns}"
  ]
}

output "output-k8s_private_workers" {
  value = [
      "k8s-workers 3 - ${aws_instance.k8s_private_workers.private_ip} - ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.k8s_private_workers.public_dns}"
  ]
}

output "output-k8s_proxy" {
  value = [
    "k8s_proxy - ${aws_instance.k8s_proxy.private_ip} - ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${aws_instance.k8s_proxy.public_dns} -o ServerAliveInterval=60"
  ]
}

output "security-group-workers-e-haproxy" {
  value = aws_security_group.k8s_acesso_workers_pf.id
}

# terraform refresh para mostrar o ssh
