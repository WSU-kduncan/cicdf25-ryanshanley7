#!/bin/bash

docker stop p4site-container || true
docker rm p4site-container || true

docker pull shanley4/p4site:latest

docker run -d \
  --name p4site-container \
  --restart always \
  -p 80:80 \
  shanley4/p4site:latest
