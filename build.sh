#!/bin/bash
# Build the Docker image
docker build -t gowdhamr/project-app:latest .

# Tag for specific environments
if [ "$1" == "prod" ]; then
  docker tag gowdhamr/project-app:latest gowdhamr/prod:latest
else
  docker tag gowdhamr/project-app:latest gowdhamr/dev:latest
fi
