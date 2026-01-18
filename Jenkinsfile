pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/tailszhang0/my-devops-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-devops-app:${BUILD_ID} .'
            }
        }

        stage('Test in Docker') {
            steps {
                sh 'docker run -d --name my-devops-app:${BUILD_ID} -p 5000:5000 my-devops-app:${BUILD_ID}'
                sh 'docker exec my-devops-app pytest test_app.py'
                sh 'docker container stop my-devops-app'
                sh 'docker container rm my-devops-app'
            }
        }
    }
}