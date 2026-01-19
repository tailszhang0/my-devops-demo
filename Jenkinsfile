pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'tails1982'
        IMAGE_NAME = 'my-devops-app'
        IMAGE_TAG = "${BUILD_ID}"
    }

    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/tailszhang0/my-devops-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG .'
                sh 'docker tag $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG $DOCKERHUB_USER/$IMAGE_NAME:latest'
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
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    docker push $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                    docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''
            }
        }

//         stage('Test in Docker') {
//             steps {
//                 sh 'docker run -d --name my-devops-app -p 5000:5000 $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG'
//                 sh 'docker exec my-devops-app pytest test_app.py'
//                 sh 'docker container stop my-devops-app'
//                 sh 'docker container rm my-devops-app'
//             }
//         }

        stage('Update K8s Manifest') {
            steps {
                sh '''
                  yq -i '.spec.template.spec.containers[0].image = "'$DOCKERHUB_USER'/'$IMAGE_NAME':'$IMAGE_TAG'"' k8s/deployment.yaml

                  git config user.name "jenkins"
                  git config user.email "jenkins@local"
                  git add k8s/deployment.yaml
                  git commit -m "chore: update image to $IMAGE_TAG"
                  git push origin main
                '''
            }
        }
    }
}