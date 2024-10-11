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
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        if (env.BRANCH_NAME == 'dev') {
                            sh 'docker tag project-app gowdhamr/dev:latest'
                            sh 'docker push gowdhamr/dev:latest'
                        } else if (env.BRANCH_NAME == 'master') {
                            // Check if this is a merge from dev to master
                            def lastCommitMsg = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                            if (lastCommitMsg.contains('Merge branch \'dev\'')) {
                                sh 'docker tag project-app gowdhamr/prod:latest'
                                sh 'docker push gowdhamr/prod:latest'
                            } else {
                                echo "Not a merge from dev, skipping push to prod repo"
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
    
    post {
        always {
            sh 'docker logout'
        }
    }
}
