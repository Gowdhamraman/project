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
                    // Checkout the code from the specified branch
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
                    // Log in to Docker Hub
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        
                        // Detect the branch from the environment (replace with the correct branch variable)
                        def branch = env.GIT_BRANCH ? env.GIT_BRANCH.split('/').last() : 'unknown'

                        // Check which branch we're working on and push accordingly
                        if (branch == 'dev') {
                            echo "Pushing to development repository..."
                            sh "docker tag project-app ${DEV_IMAGE_NAME}"
                            sh "docker push ${DEV_IMAGE_NAME}" // Push the image to Docker Hub
                        } else if (branch == 'main') {
                            echo "Pushing to production repository..."
                            sh "docker tag project-app ${PROD_IMAGE_NAME}"
                            sh "docker push ${PROD_IMAGE_NAME}" // Push the image to Docker Hub
                        } else {
                            echo "Not a valid branch for pushing images. Current branch: ${branch}"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deploy the application using the deploy.sh script
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

