#!/bin/bash
set -e
PASSWORD=''
echo "$PASSWORD" > ansiblepass

ansible-playbook -i hosts.yml site.yml --vault-password-file ansiblepass

rm ansiblepass