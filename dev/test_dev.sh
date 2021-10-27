#!/bin/bash

cd terraform

CURL=$(curl http://18.230.123.199:30002/login)

regex='Seja muito bem vindo' 

if [[ $CURL =~ $regex ]] 
then 
   echo "App java no ar"
else
   echo "App java fora"
fi