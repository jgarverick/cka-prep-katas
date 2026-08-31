#!/usr/bin/env bash
set -euo pipefail
sed -i 's#/usr/bin/kublet#/usr/bin/kubelet#' /tmp/cka-prep-labs/13-kubelet.service
