#!/usr/bin/env bash

# Uncomment for debugging
#set -x
#set -e

minishift addons enable anyuid
minishift addons enable admin-
minishift addons enable xpaas
minishift addons disable che
minishift addons disable registry-route

minishift config set network-nameserver 8.8.8.8

minishift start --skip-registration --iso-url=centos --cpus=4 --memory=10GB --vm-driver=virtualbox

DOCKER_COMMAND="docker run -v $HOME/.kube/config:/openshift-applier/.kube/config:z -w /tmp/my-inventory -u root -v $PWD:/tmp/my-inventory -e INVENTORY_PATH=/tmp/my-inventory -t redhatcop/openshift-applier"

oc login -u developer -p developer --insecure-skip-tls-verify=true https://$(minishift ip):8443/

${DOCKER_COMMAND} ./clean-unique-names.sh

${DOCKER_COMMAND} ansible-galaxy install -r requirements.yml --roles-path=roles

${DOCKER_COMMAND} ansible-playbook apply.yml -i inventory/ -e target=bootstrap

${DOCKER_COMMAND} ansible-playbook apply.yml -i inventory/ -e target=tools

${DOCKER_COMMAND} ansible-playbook apply.yml -i inventory/ -e target=apps


