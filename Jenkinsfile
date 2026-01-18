pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url
            }
        }

        stage('Test') {
            steps {
                sh 'pytest test_app.py'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-devops-app:${env.BUILD_ID}")
                }
            }
        }
    }
}