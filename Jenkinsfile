pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-logins'
        DEV_IMAGE_NAME = 'gowdhamr/dev:latest'
        PROD_IMAGE_NAME = 'gowdhamr/prod:latest'
        GITHUB_REPO_URL = 'https://github.com/Gowdhamraman/project.git'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the code from the repository
                    git branch: env.BRANCH_NAME ?: 'main', url: env.GITHUB_REPO_URL
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh './build.sh'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Docker login and push based on the branch
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        
                        if (env.BRANCH_NAME == 'dev') {
                            echo "Pushing to the development repository..."
                            sh "docker tag project-app ${DEV_IMAGE_NAME}"
                            sh "docker push ${DEV_IMAGE_NAME}"
                        } else if (env.BRANCH_NAME == 'main') {
                            echo "Pushing to the production repository..."
                            sh "docker tag project-app ${PROD_IMAGE_NAME}"
                            sh "docker push ${PROD_IMAGE_NAME}"
                        } else {
                            echo "Invalid branch. Skipping Docker push."
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deploy the application
                    sh './deploy.sh'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

