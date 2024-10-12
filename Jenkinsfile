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
                // Checkout the code from the specific branch
                git branch: env.BRANCH_NAME, url: env.GITHUB_REPO_URL
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
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"

                        // Determine which image to push based on the branch
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker tag project.app ${DEV_IMAGE_NAME}"
                            sh "docker push ${DEV_IMAGE_NAME}"
                        } 
                        else if (env.BRANCH_NAME == 'main') {  // If your branch is 'main', not 'master'
                            sh "docker tag project.app ${PROD_IMAGE_NAME}"
                            sh "docker push ${PROD_IMAGE_NAME}"
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

