#!/bin/bash
set -ev

readonly REPO_NAME="${1}"

readonly TMP_DIR=$(mktemp -d)
trap remove_tmp_dir EXIT

remove_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }

cd "${TMP_DIR}"
git clone "https://github.com/cyber-dojo/${REPO_NAME}.git"
cd "${REPO_NAME}"
echo "${CIRCLE_SHA1}" > starter-base.trigger
git add .
git config --global user.email "cyber-dojo-machine-user@cyber-dojo.org"
git config --global user.name "Machine User"
git commit -m "automated build trigger from cyberdojo/starter-base ${CIRCLE_SHA1}"
git push origin master
