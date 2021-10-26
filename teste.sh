#!/bin/bash

cd terraform

CURL=$(curl "http://$(terraform output |grep IP| sed 's/IP//g'|sed 's/,//g'|sed 's/ //g'|sed 's/"//'|sed 's/"//')")

regex='Welcome to nginx!' 

if [[ $CURL =~ $regex ]] 
then 
   echo "nginx no ar"
else
   echo "nginx fora"
fi
