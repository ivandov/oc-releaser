#!/bin/bash

# TODOs:
# - Make cross-arch/platform compatible (at least OSX and linux)
# - Revert to using the official conventional-changelog plugin when PR is merged

npm install -g release-it
# Fork until this PR is merged: https://github.com/release-it/conventional-changelog/pull/27
npm install -g https://github.com/ivandov/conventional-changelog
pip install ansible-core
sudo wget "https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_amd64" -O /usr/bin/yq
sudo chmod +x /usr/bin/yq