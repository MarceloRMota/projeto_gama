#!/bin/bash
cd build
docker login -u=celo -p=M@rcelo123
docker build -t celo/projeto_final:0.0.2 -f Dockerfile .
docker tag celo/projeto_final:0.0.2 hub.docker.com/r/celo/projeto_final
docker push celo/projeto_final:0.0.2