pipeline {
    agent any

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'dev', description: 'Branch to build')
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-logins'
        DEV_IMAGE_NAME = 'gowdhamr/dev:latest'
        PROD_IMAGE_NAME = 'gowdhamr/prod:latest'
        GITHUB_REPO_URL = 'https://github.com/Gowdhamraman/project.git'
        DOCKER_IMAGE_NAME = 'gowdhamr/project-app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Check out the specific branch
                    git branch: params.BRANCH_NAME ?: 'main', url: env.GITHUB_REPO_URL
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh './build.sh'  // Ensure this script builds and tags the image as $DOCKER_IMAGE_NAME
                }
            }
        }

        stage('Debug Branch') {
            steps {
                script {
                    // Print the current branch for debugging purposes
                    echo "Branch detected: ${params.BRANCH_NAME}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"

                        if (params.BRANCH_NAME == 'dev') {
                            echo "Pushing to development repository..."
                            sh "docker tag ${DOCKER_IMAGE_NAME} ${DEV_IMAGE_NAME}"
                            sh "docker push ${DEV_IMAGE_NAME}"
                        } else if (params.BRANCH_NAME == 'main' || params.BRANCH_NAME == 'prod') {
                            echo "Pushing to production repository..."
                            sh "docker tag ${DOCKER_IMAGE_NAME} ${PROD_IMAGE_NAME}"
                            sh "docker push ${PROD_IMAGE_NAME}"
                        } else {
                            echo "Branch is not dev or main/prod, skipping push."
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

        stage('Debug Environment') {
            steps {
                script {
                    // Print all for debug
                    sh "env"
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

