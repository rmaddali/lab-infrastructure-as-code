#!/usr/bin/env bash

oc login -u user1 -p "r3dh4t1!" --insecure-skip-tls-verify=true https://master.dff8.openshift.opentlc.com/

ansible-galaxy install -t requirements.yml --roles-path=roles

ansible-playbook apply.yml -i inventory/ -e target=bootstrap

ansible-playbook apply.yml -i inventory/ -e target=tools