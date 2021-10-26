mkdir image

cd terraform
IMAGE=$(terraform output| grep "i-"|sed  's/,//g')
cat <<EOF > ../image/print.tf
provider "aws" {
  region = "sa-east-1"
}

resource "aws_ami_from_instance" "k8s_projeto_final" {
  name               = "k8s_projeto_final"
  source_instance_id = ${IMAGE}
}
output "ami" {
  value = aws_ami_from_instance.k8s_projeto_final.id
  
}
EOF
cd ../image/
terraform init
terraform fmt
terraform apply -auto-approve
