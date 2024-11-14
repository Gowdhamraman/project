#**DevOps React Application Deployment**

This project demonstrates a complete CI/CD pipeline for deploying a React application using Docker, Docker Hub, Jenkins, and AWS. The pipeline includes automatic build triggers, version control, and monitoring setup.

*Table of Contents*

1. Project Structure
2. Steps to Deploy
3. Scripts
4. Jenkins Multibranch Pipeline Configuration
5. Docker Repositories
6. AWS Deployment
7. Monitoring


**Project Structure**
.
```
├── build
├── build.sh
├── deploy.sh
├── docker-compose.yml
├── Dockerfile
├── Jenkinsfile
└── nginx.conf 
```

Files and Directories

build/: Contains the static assets for the React application.
Dockerfile: Defines the Docker image setup for the application.
docker-compose.yml: Manages container orchestration for deployment.
nginx.conf: Configuration file for serving the application via NGINX.
build.sh: Script to build the Docker image.
deploy.sh: Script to deploy the image to the server.

**Steps to Deploy**

Clone the Repository


```git clone https://github.com/sriram-R-krishnan/devops-build```

```cd devops-build```

Dockerize the Application

Build the Docker image with build.sh.
Run deploy.sh to deploy the image to your server.
Push to GitHub

Use the CLI to push all changes to the dev branch on GitHub, including dockerignore and gitignore files.
Docker Hub Repositories

Create two repositories in Docker Hub:
dev (public)
prod (private)
Images will be pushed to these repositories based on the branch.
Jenkins Pipeline Setup

Configure a Jenkins pipeline to trigger builds:
Dev Branch: Pushes images to the public dev repository on Docker Hub.
Master Branch: Pushes images to the private prod repository on Docker Hub.
Connect Jenkins to the GitHub repo with webhooks for automated builds.
AWS Deployment

Launch a t2.micro instance on AWS with the following security settings:
HTTP port 80 accessible to all.
SSH access restricted to your IP only.
Monitoring Setup

Install an open-source monitoring tool (e.g., Prometheus, Grafana, or Monit) to check application health.
Configure alerts to notify if the application goes down.


**Scripts**

build.sh: Builds the Docker image and tags it.


```
#!/bin/bash
# Build the Docker image
docker build -t gowdhamr/project-app:latest .

```

deploy.sh: Deploys the Docker image to the server.


```
#!/bin/bash
docker compose down
docker compose up -d
echo " Process completed!"
```
**Jenkins Multibranch Pipeline Configuration**

Jenkinsfile: Pipeline configuration.

Build: Builds Docker images from both dev and master branches.
Push: Pushes images to Docker Hub based on branch (dev or prod).

Deploy: Deploys to AWS if code is in master.
GitHub Webhook: Set up a webhook to trigger builds on push to dev or master.

**Docker Repositories**

Docker Hub Public Repository: my-docker-hub-username/dev
Docker Hub Private Repository: my-docker-hub-username/prod


**AWS Deployment**

Instance Type: t2.micro
Security Group:
HTTP (Port 80): Accessible to all.
SSH (Port 22): Restricted to your IP.

**Monitoring**

Set up monitoring to:

Track application health.
Send notifications when the application is down.
Suggested tools:

Prometheus and Grafana: For advanced metrics and alerting.
Monit: Lightweight tool to monitor and restart the application if it goes down.
