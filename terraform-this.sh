#!/usr/bin/env bash

project="${1:-.}"
current=$(pwd)

cd "$project" || exit 1

terraform init .

case "$2" in
  "destroy")
    terraform destroy -auto-approve -var-file="$current/config/$project.tfvars" .
  ;;
  *)
    terraform apply -auto-approve -var-file="$current/config/$project.tfvars" .
  ;;
esac

cd - || exit 1
