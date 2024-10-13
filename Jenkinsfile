pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-logins')
        DOCKER_IMAGE = 'gowdhamr/project-app:latest' // Updated to include the tag
        DEV_REPO = 'gowdhamr/dev'
        PROD_REPO = 'gowdhamr/prod'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh './build.sh' // This builds and tags as gowdhamr/project-app:latest
            }
        }

        stage('Debug Branch') {  
            steps {
                script {
                    sh "echo 'Current branch: ${env.BRANCH_NAME}'"
                }
            }
        }

        stage('Push to Docker Hub - Development') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag ${DOCKER_IMAGE} ${DEV_REPO}:latest"
                        sh "docker push ${DEV_REPO}:latest"
                    }
                }
            }
        }

        stage('Push to Docker Hub - Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag ${DOCKER_IMAGE} ${PROD_REPO}:latest"
                        sh "docker push ${PROD_REPO}:latest"
                    }
                }
            }
        }
    }

    post {
pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-logins')
        DOCKER_IMAGE = 'gowdhamr/project-app:latest' // Updated to include the tag
        DEV_REPO = 'gowdhamr/dev'
        PROD_REPO = 'gowdhamr/prod'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh './build.sh' // This builds and tags as gowdhamr/project-app:latest
            }
        }

        stage('Debug Branch') {  
            steps {
                script {
                    sh "echo 'Current branch: ${env.BRANCH_NAME}'"
                }
            }
        }

        stage('Push to Docker Hub - Development') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag ${DOCKER_IMAGE} ${DEV_REPO}:latest"
                        sh "docker push ${DEV_REPO}:latest"
                    }
                }
            }
        }

        stage('Push to Docker Hub - Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag ${DOCKER_IMAGE} ${PROD_REPO}:latest"
                        sh "docker push ${PROD_REPO}:latest"
                    }
                }
            }
        }
    }

    post {
        sucess {
            echo 'Pipeline was successful!'
        }
    }
       failure {
            echo 'Pipeline failed!'
        }
    }
}

