pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-loginx'
        DEV_IMAGE_NAME = 'gowdhamr/dev:latest'
        PROD_IMAGE_NAME = 'gowdhamr/prod:latest' 
        GITHUB_REPO_URL = 'https://github.com/Gowdhamraman/project.git' 
    }

    stages {
        stage('Checkout') {
            steps {
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
                    // Push to dev repository if on dev branch
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker login -u gowdhamr -p dckr_pat_BD-JsJ2EJ9E_WFMPX9pk3qlEyQQ" 
                        sh "docker tag <project.app> ${DEV_IMAGE_NAME}"
                        sh "docker push ${DEV_IMAGE_NAME}"
                    } 
                    // Push to prod repository if on master branch
                    else if (env.BRANCH_NAME == 'master') {
                        sh "docker login -u gowdhamr -p dckr_pat_BD-JsJ2EJ9E_WFMPX9pk3qlEyQQ" 
                        sh "docker tag <project.app> ${PROD_IMAGE_NAME}"
                        sh "docker push ${PROD_IMAGE_NAME}"
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
