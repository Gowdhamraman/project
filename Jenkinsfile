pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-logins'
        DEV_IMAGE_NAME = 'gowdhamr/dev:latest'
        PROD_IMAGE_NAME = 'gowdhamr/prod:latest' 
        GITHUB_REPO_URL = 'https://github.com/Gowdhamraman/project.git' 
        DOCKER_IMAGE_NAME = 'gowdhamr/project-app:latest'  // Define the Docker image name
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the specific branch
                git branch: env.BRANCH_NAME ?: 'main', url: env.GITHUB_REPO_URL
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh './build.sh'  // Ensure this script builds and tags the image as $DOCKER_IMAGE_NAME
                }
            }
        }

        stage('Debug Branch') {  
            steps {
                script {
                    sh "echo 'Current branch: ${env.BRANCH_NAME}'"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"

                        // Determine which image to push based on the branch
                        if (env.BRANCH_NAME == 'dev') {
                            echo "Detected branch: dev"
                            echo "Pushing to development repository..."
                            sh "docker tag ${DOCKER_IMAGE_NAME} ${DEV_IMAGE_NAME}"
                            sh "docker push ${DEV_IMAGE_NAME}"
                        } 
                        else if (env.BRANCH_NAME == 'main') {  // If your branch is 'main'
                            echo "Detected branch: main"
                            echo "Pushing to production repository..."
                            sh "docker tag ${DOCKER_IMAGE_NAME} ${PROD_IMAGE_NAME}"
                            sh "docker push ${PROD_IMAGE_NAME}"
                        } else {
                            echo "No valid branch detected for pushing images."
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deploy the application using deploy.sh
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

