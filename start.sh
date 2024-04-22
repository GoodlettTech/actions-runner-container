#!/bin/bash

cd /home/docker/actions-runner

echo -e "\n\n\n~/actions-runner/_work" | ./config.sh --url https://github.com/$REPO_SLUG --token $TOKEN

./run.sh
