#!/usr/bin/env bash

oc login -u user1 -p "r3dh4t1!" --insecure-skip-tls-verify=true https://master.dff8.openshift.opentlc.com/

ansible-galaxy install -r requirements.yml --roles-path=roles

ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=user1" -e target=bootstrap

ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=user1" -e target=tools