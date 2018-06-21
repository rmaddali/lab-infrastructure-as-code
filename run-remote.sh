#!/usr/bin/env bash

set -x
set -e

export USERNAME='user10'

oc login -u ${USERNAME} -p "r3dh4t1!" --insecure-skip-tls-verify=true https://master.qcon.openshift.opentlc.com/

DOCKER_COMMAND="docker run -v $HOME/.kube/config:/openshift-applier/.kube/config:z -w /tmp/my-inventory -u root -v $PWD:/tmp/my-inventory -e INVENTORY_PATH=/tmp/my-inventory -t redhatcop/openshift-applier"

${DOCKER_COMMAND} ./clean-unique-names.sh

${DOCKER_COMMAND} ansible-galaxy install -r requirements.yml --roles-path=roles

${DOCKER_COMMAND} ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=bootstrap

${DOCKER_COMMAND} ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=tools

${DOCKER_COMMAND} ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=apps
