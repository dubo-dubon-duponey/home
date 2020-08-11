#!/usr/bin/env bash

project="${1:-.}"
current=$(pwd)

cd "$project" || exit 1

case "$2" in
  "plan")
    terraform init .
    terraform plan -var-file="$current/config/$project.tfvars" .
  ;;
  "destroy")
    terraform destroy -auto-approve -var-file="$current/config/$project.tfvars" .
  ;;
  "output")
    terraform output
  ;;
  *)
    terraform init .
    terraform apply -auto-approve -var-file="$current/config/$project.tfvars" .
  ;;
esac

cd - >/dev/null || exit 1
