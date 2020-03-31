#!/bin/bash
set -euxo pipefail

# Rebase PRs on master to get latest changes
if [[ $CI_COMMIT_REF_NAME == pr-* ]]; then
  git config user.email "ci@kubespray.io"
  git config user.name "CI"
  git pull --rebase origin release-2.11
fi
