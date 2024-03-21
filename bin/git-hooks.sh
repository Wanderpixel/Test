#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.config.sh"

if [ -d "${ROOT_DIR}/.git" ]; then
  echo "Git directory exists"
else
  echo "[WARNING] Git directory does not exist"
  echo "[WARNING] Skipping Symlinking"
  exit 0
fi

if [[ -L "${ROOT_DIR}/.git/hooks/$1" ]]; then
  echo "Symlinking for $1 exists"
else
  ln -s "$ROOT_DIR/.hooks/$1" "$ROOT_DIR/.git/hooks/$1"
  echo "Symlinking for $1 successfully created"
fi

exit 0