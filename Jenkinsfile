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
                    git branch: params.BRANCH_NAME ?: 'dev', url: env.GITHUB_REPO_URL
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh './build.sh' 
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"

                        if (params.BRANCH_NAME == 'dev') {
                            echo "Pushing to dev repo..."
                            sh "docker push ${DEV_IMAGE_NAME}"
                        } else if (params.BRANCH_NAME == 'main') {
                            echo "Pushing to prod repo..."
                            sh "docker push ${PROD_IMAGE_NAME}"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh './deploy.sh'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}

