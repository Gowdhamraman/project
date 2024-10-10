#!/bin/bash

docker-compose build

docker tag devops-build gowdhamr/dev:latest
