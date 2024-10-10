pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO_DEV = 'gowdhamr/dev'
        DOCKER_HUB_REPO_PROD = 'gowdhamr/prod'
        DOCKER_HUB_CREDENTIALS = 'docker-hub' // ID of Docker Hub credentials
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/Gowdhamraman/project.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO_DEV}:latest")
                }
            }
        }
        stage('Push Docker Image to Dev') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Push Docker Image to Prod') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
