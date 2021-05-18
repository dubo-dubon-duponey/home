#!/usr/bin/env bash

project="${1:-.}"
current="$(pwd)"
case "$2" in
  "plan")
    terraform -chdir="$1" init
    terraform -chdir="$1" plan -var-file="$current/config/$project.tfvars"
  ;;
  "destroy")
    terraform -chdir="$1" destroy -auto-approve -var-file="$current/config/$project.tfvars"
  ;;
  "output")
    terraform -chdir="$1" output
  ;;
  *)
    terraform -chdir="$1" init
    terraform -chdir="$1" apply -auto-approve -var-file="$current/config/$project.tfvars"
  ;;
esac
