#!/bin/bash

cd terraform 
terraform init
terraform fmt
terraform apply -auto-approve

echo [k8s-host] >  ../ansible/hosts
terraform output |grep Master| sed 's/Master//g'|sed 's/,//g'|sed 's/ //g' >> ../ansible/hosts

sleep 10