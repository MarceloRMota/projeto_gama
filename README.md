<h1>Sobre o projeto:</h1>

Projeto criado para apresentar o conteúdo aprendido durante o treinamento ministrado pela gamma academy. 

<h2>Observações:</h2>

Decidimos por separar cada etapa do desafio pro branch:
 - main - Criação do IAM com kubernetes instalado a partir de uma instância configurada;
 - cmm - Criação de um cluster multimaster de kubernetes a partir da imagem gerada no step anterior;
 - db - Criação de  uma instancia com mysql instalado e com 3 databases (DEV/STAGE/PRD);
 - spring - Pipelide de dev com build aplicação jaca, TDD, build docker image, pull no docker hub e deploy de 3 pods dev/stage/prd cada um conectando em sua base de dados;
 
<h2>Pré requisitos:</h2>

Uma VPC com:
  - Subnets públicas e subnet privada para utilizar nas instancias de banco;
  - Internet gateway;
  - NAT gateway;


Servidor de jenkins na vpc com as seguintes tecnologias instaladas:
  - Maven
  - Java
  - Docker
  - Docker io
  - Usuario e grupo docker:docker;
  - Ansible
  - Ansible-galaxy collection install community.mysql
  


<h2>Abaixo o conteúdo dos jenkinsfile separados por branch:</h2>

Branch main

        ('Clone scripts deploy') 
                git url:'https://github.com/MarceloRMota/projeto_gama.git', branch: 'main'
				
        ('Deploy EC2') 
                sh "~/workspace/criando_iam_kubernetes/deploy_ec2.sh"
				
        ('Deploy k8s') 
                sh "~/workspace/criando_iam_kubernetes/deploy_k8s.sh"
				
        ('Test k8s') 
                sh "~/workspace/criando_iam_kubernetes/teste.sh"
				
        ('Create Image') 
                sh "~/workspace/criando_iam_kubernetes/image.sh"
				
        ('Destroy a instancia EC2') 
                sh "~/workspace/criando_iam_kubernetes/destroy.sh"


Branch cmm

        ('Clone scripts deploy') 
                git url:'https://github.com/MarceloRMota/projeto_gama.git', branch: 'cmm'
				
        ('Deploy EC2/IAM/K8S') 
                sh "~/workspace/criando_k8s_mm/deploy.sh"


Branch db

        ('Clone scripts deploy') 
                git url:'https://github.com/MarceloRMota/projeto_gama.git', branch: 'db'
				
        ('Deploy EC2') 
                sh "~/workspace/criando_DB/deploy.sh"
				
        ('Configurando as Bases DEV-STAGE-DB') 
                sh "~/workspace/criando_DB/configurar.sh"

Branch spring

     ('Build') 
        git url: 'https://github.com/MarceloRMota/projeto_gama.git', branch: 'spring'
        sh '~/workspace/deploy_desenv/build.sh'
 
	   ('TDD') 
        sh '~/workspace/deploy_desenv/test_build.sh'
 
     ('Docker image/push') 
        sh "~/workspace/deploy_desenv/docker_deploy.sh"
		
     ('K8s-DEV') 
        sh '~/workspace/deploy_desenv/deploy_dev.sh'
		
     ('K8s-STAGE') 
        sh '~/workspace/deploy_desenv/deploy_stage.sh'
		
     ('K8s-PROD') 
        sh '~/workspace/deploy_desenv/deploy_prd.sh'
 
