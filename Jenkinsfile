pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-logins'
        DOCKER_DEV_REPO = 'gowdhamr/dev'
        DOCKER_PROD_REPO = 'gowdhamr/prod'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the branch
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh './build.sh'  // Using the build.sh script to build the image
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Check if branch is dev or main and push accordingly
                    if (env.GIT_BRANCH == 'origin/dev') {
                        withCredentials([string(credentialsId: "$DOCKER_CREDENTIALS_ID", variable: 'DOCKER_PASS')]) {
                            sh "echo $DOCKER_PASS | docker login -u gowdhamr --password-stdin"
                            sh 'docker tag project-app $DOCKER_DEV_REPO:latest'
                            sh 'docker push $DOCKER_DEV_REPO:latest'
                        }
                    } else if (env.GIT_BRANCH == 'origin/main') {
                        withCredentials([string(credentialsId: "$DOCKER_CREDENTIALS_ID", variable: 'DOCKER_PASS')]) {
                            sh "echo $DOCKER_PASS | docker login -u gowdhamr --password-stdin"
                            sh 'docker tag project-app $DOCKER_PROD_REPO:latest'
                            sh 'docker push $DOCKER_PROD_REPO:latest'
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
