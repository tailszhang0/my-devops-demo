pipeline {
    agent {
        docker {
            image 'python:3.9-slim'
            args '-u root'
        }
    }

    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/tailszhang0/my-devops-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-devops-app:${env.BUILD_ID}")
                }
            }
        }

        stage('Test') {
            steps {
                sh 'pytest test_app.py'
            }
        }
    }
}