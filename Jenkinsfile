pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO_DEV = 'gowdhamr/dev'
        DOCKER_HUB_REPO_PROD = 'gowdhamr/prod'
        DOCKER_HUB_CREDENTIALS = 'docker-logins' // ID of Docker Hub credentials
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
                git branch: 'dev', url: 'https://github.com/Gowdhamraman/project.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    dockerImage = docker.build("${DOCKER_HUB_REPO_DEV}:latest")
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Add commands to run tests here
                    echo 'Running tests...'
                    // Example: sh 'docker run --rm ${dockerImage.id} test-command'
                }
            }
        }
        stage('Push Docker Image to Dev') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    // Push the image to the dev repository on Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Build Prod Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    // Tag the image for production
                    dockerImage.tag("${DOCKER_HUB_REPO_PROD}:latest")
                }
            }
        }
        stage('Push Docker Image to Prod') {
            when {
                branch 'master'
            }
            steps {
                script {
                    // Push the tagged image to the prod repository on Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
