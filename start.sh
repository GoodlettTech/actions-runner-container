#!/bin/bash

cd /home/docker/actions-runner

echo -e "\n\n\n/work" | ./config.sh --url https://github.com/$REPO_SLUG --token $TOKEN

./run.sh
