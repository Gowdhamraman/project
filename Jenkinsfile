pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-logins')
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

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        if (env.BRANCH_NAME == 'dev') {
                            // Tag and push the image for the 'dev' branch
                            sh 'docker tag project-app gowdhamr/dev:latest'
                            sh 'docker push gowdhamr/dev:latest'
                        } else if (env.BRANCH_NAME == 'master') {
                            // Only push to production if the last commit is a merge from 'dev'
                            def isMergeFromDev = sh(script: 'git log -1 --pretty=%B', returnStdout: true).contains('Merge branch \'dev\'')
                            if (isMergeFromDev) {
                                sh 'docker tag project-app gowdhamr/prod:latest'
                                sh 'docker push gowdhamr/prod:latest'
                            } else {
                                echo "Skipping push to production, not a merge from 'dev'."
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
