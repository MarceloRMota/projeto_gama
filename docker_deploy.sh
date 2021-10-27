#!/bin/bash
cd build
export DOCKER_USERNAME="celo"
export DOCKER_PASSWORD="M@rcelo123"
docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
docker build -t celo/projeto_final:0.0.2 -f Dockerfile .
docker tag celo/projeto_final:0.0.2 hub.docker.com/r/celo/projeto_final
docker push celo/projeto_final:0.0.2