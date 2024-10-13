pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-logins')
        DOCKER_IMAGE = 'gowdhamr/project-app'
        DEV_REPO = 'gowdhamr/dev'
        PROD_REPO = 'gowdhamr/prod'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                sh './build.sh'
            }
        }
        stage('Debug Branch') {  // Add this stage for debugging
            steps {
                script {
                    sh "echo 'Current branch: ${env.BRANCH_NAME}'"
                }
            }
        }
        stage('Push to Docker Hub') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag ${DOCKER_IMAGE}:latest ${DEV_REPO}:latest"
                        sh "docker push ${DEV_REPO}:latest"
                    }
                }
            }
        }
        stage('Push to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag ${DOCKER_IMAGE}:latest ${PROD_REPO}:latest"
                        sh "docker push ${PROD_REPO}:latest"
                    }
                }
            }
        }
    }
    post {
        failure {
            echo 'Pipeline failed!'
        }
    }
}

