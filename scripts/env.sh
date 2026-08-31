#!/usr/bin/env bash
# shellcheck shell=bash

alias k=kubectl
export do='--dry-run=client -o yaml'
export now='--force --grace-period=0'

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl k
fi

cat <<'VIMRC'
Add this snippet to your ~/.vimrc:
set expandtab tabstop=2 shiftwidth=2
VIMRC
