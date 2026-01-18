pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'tails1982'
        IMAGE_NAME = 'my-devops-app'
    }

    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/tailszhang0/my-devops-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:${BUILD_ID} .'
                sh 'docker tag $IMAGE_NAME:${BUILD_ID} $IMAGE_NAME:latest'
            }
        }

        stage('Login Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                            credentialsId: '6f86dba6-4860-4227-bb8c-96df6afde329',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASS'
                        )
                    ]
                ) {
                    sh '''
                        docker login -u $DOCKER_USER --password $DOCKER_PASS
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    docker push DOCKERHUB_USER/$IMAGE_NAME:${BUILD_ID}
                    docker push DOCKERHUB_USER/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Test in Docker') {
            steps {
                sh 'docker run -d --name my-devops-app -p 5000:5000 $IMAGE_NAME:${BUILD_ID}'
                sh 'docker exec my-devops-app pytest test_app.py'
                sh 'docker container stop my-devops-app'
                sh 'docker container rm my-devops-app'
            }
        }
    }
}