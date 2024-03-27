#!/bin/bash

# DEV or PROD
NAMESPACE=DEV

if [ $NAMESPACE = 'DEV' ]
then
    ns='dev'
elif [ $NAMESPACE = 'PROD' ]
then
    ns='prod'
else
    echo Wrong namespace name $NAMESPACE
    exit 1
fi

kubectl config use-context myadmin@kubernetes
kubectl config set "contexts."`kubectl config current-context`".namespace" $ns
echo Namespace set to $ns

set -e
PASSWORD=''
echo "$PASSWORD" > ansiblepass

ansible-playbook site.yml --vault-password-file ansiblepass

rm ansiblepass