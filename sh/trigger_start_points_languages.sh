#!/bin/bash
set -ev

# This script runs in .circleci/config.yml after
# a cyberdojo/start-points-base docker image is
# successfully created.
# Originally instead of a git commit+push the .yml file did a
#
# curl --fail -X POST https://circleci.com/api/v1.1/project/github/cyber-dojo/start-points-languages/build?circle-token=${CIRCLECI_BUILD_TOKEN}
#
# The problems with this approach are
# o) when the trigger reached start-points-languages .circleci/config.yml
#    its Helm commands did not see a SHA change, so did not see an
#    image-tag change, and so did not do a deployment.
# o) Since the SHA did not change, the image was being built
#    with the same tag multiple times. Not good practice.
#
# To avoid these problems we now do a regular git commit+push.

cd /tmp
git clone https://github.com/cyber-dojo/start-points-languages.git
cd start-points-languages
echo "${CIRCLE_SHA1}" > start-points-base.trigger
git add .
git config --global user.email "jon@jaggersoft.com"
git config --global user.name "Jon Jagger"
git commit -m "automated build trigger from cyberdojo/start-points-base ${CIRCLE_SHA1}"
curl -u JonJagger:${GITHUB_TRIGGER_TOKEN} https://api.github.com/user
# List the remotes. Is origin SSH? If so it needs to be HTTPS
#git remote -v
#ssh-add -D
# Switch protocol to https
git remote set-url origin https://github.com/cyber-dojo/start-points-languages.git
git push origin master
