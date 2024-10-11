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
                        sh 'docker push gowdhamr/dev:latest'
                    } else if (env.BRANCH_NAME == 'main') {
                        sh 'docker push gowdhamr/prod:latest'
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
