#!/usr/bin/env bash

minishift addons enable anyuid
minishift addons enable admin-user
minishift addons enable xpaas
minishift addons disable che
minishift addons disable registry-route

minishift config set network-nameserver 8.8.8.8

minishift start --skip-registration --iso-url=centos --cpus=4 --memory=10GB --vm-driver=virtualbox

oc login -u developer -p developer --insecure-skip-tls-verify=true https://$(minishift ip):8443/

ansible-galaxy install -r requirements.yml --roles-path=roles

ansible-playbook apply.yml -i inventory/ -e target=bootstrap

ansible-playbook apply.yml -i inventory/ -e target=tools

#ansible-playbook apply.yml -i inventory/ -e target=apps
