#!/bin/bash

# TODOs:
# - Make cross-arch/platform compatible (at least OSX and linux)
# - Revert to using the official conventional-changelog plugin when PR is merged


echo "Installing release-it and oc-releaser pre-reqs"
npm install -g release-it
npm install -g @release-it/conventional-changelog
pip install ansible-core
sudo wget "https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_amd64" -O /usr/bin/yq
sudo chmod +x /usr/bin/yq

echo "Running in a Travis environment, re-attaching git HEAD to ${TRAVIS_BRANCH}"
git remote rm origin
git remote add origin https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
git symbolic-ref HEAD "refs/heads/${TRAVIS_BRANCH}"
