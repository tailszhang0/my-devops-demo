pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/tailszhang0/my-devops-demo.git'
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