#!/usr/bin/env bash

set -x
set -e

## Remove any user-specific settings from the inventory
egrep -r "user[0-9]*" * | awk -F":" '{print $1}' | sort | uniq | grep -v openshift-template | xargs -n 1 sed -i 's@ (user[0-9]*)$@@g'
egrep -r "user[0-9]*" * | awk -F":" '{print $1}' | sort | uniq | grep -v openshift-template | xargs -n 1 sed -i 's@user[0-9]*$@@g'

export USERNAME='user10'

oc login -u ${USERNAME} -p "r3dh4t1!" --insecure-skip-tls-verify=true https://master.qcon.openshift.opentlc.com/

DOCKER_COMMAND="docker run -v $HOME/.kube/config:/openshift-applier/.kube/config:z -w /tmp/my-inventory -u root -v $PWD:/tmp/my-inventory -e INVENTORY_PATH=/tmp/my-inventory -t redhatcop/openshift-applier"

${DOCKER_COMMAND} ansible-galaxy install -r requirements.yml --roles-path=roles

${DOCKER_COMMAND} ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=bootstrap

${DOCKER_COMMAND} ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=tools

${DOCKER_COMMAND} ansible-playbook unique-projects-playbook.yaml -i inventory/ -e "project_name_postfix=${USERNAME}" -e target=apps
