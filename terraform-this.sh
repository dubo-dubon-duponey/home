#!/usr/bin/env bash
set -o errexit -o errtrace -o functrace -o nounset -o pipefail

readonly project="nodes/${1:-.}"
readonly command="${2:-apply}"
readonly current="$(pwd)"

terraform -chdir="$project" init

case "$command" in
  "output")
    terraform -chdir="$project" "$command"
  ;;
  "plan")
    terraform -chdir="$project" "$command" -var-file="$current/config/$project.tfvars"
  ;;
  #"apply")
  #"destroy")
  *)
    terraform -chdir="$project" "$command" -auto-approve -var-file="$current/config/$project.tfvars"
  ;;
esac
