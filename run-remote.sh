#!/usr/bin/env bash

set -x
set -e

export USERNAME='user10'

oc login -u ${USERNAME} -p "r3dh4t1!" --insecure-skip-tls-verify=true https://master.qcon.openshift.opentlc.com/

ansible-galaxy install -r requirements.yml --roles-path=roles

ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=bootstrap

ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=tools

ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=apps
