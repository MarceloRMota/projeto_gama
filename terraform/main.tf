provider "aws" {
  region = "sa-east-1"
}


resource "aws_instance" "pf-db" {
  ami                         = "ami-054a31f1b3bf90920"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0ba351a68949c6953"
  key_name                    = "jenkins_key"
  associate_public_ip_address = true
  tags = {
    Name = "maquina_db"
  }
    root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  vpc_security_group_ids = ["${aws_security_group.acessos_db.id}"]
}


# terraform refresh para mostrar o ssh
output "Database" {
  value = [
    "IP ${aws_instance.pf-db.private_ip}",
    "ssh  ubuntu@${aws_instance.pf-db.private_dns}"
  ]
}