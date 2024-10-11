pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh './build.sh'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'docker push yourusername/dev:latest'
                    } else if (env.BRANCH_NAME == 'master') {
                        sh 'docker push yourusername/prod:latest'
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
