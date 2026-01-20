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

        stage('Test in Container') {
            steps {
                sh '''
                  docker run -d --name test-app -p 5000:5000 $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG

                  echo "Waiting for Flask app to start..."

                  for i in {1..10}; do
                      if docker exec test-app curl -f http://localhost:5000/health; then
                        break
                      fi

                      sleep 1
                  done

                  docker exec test-app pytest /app/test_app.py

                  docker stop test-app
                  docker rm test-app
                '''
            }
        }

        stage('Login Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                            credentialsId: 'docker-hub-creds',
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

        stage('Update K8s Manifest') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'git-hub-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {
                    sh '''
                      git config user.name "jenkins"
                      git config user.email "jenkins@local"

                      git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/tailszhang0/my-devops-demo.git

                      yq -i '.spec.template.spec.containers[0].image = "'$DOCKERHUB_USER'/'$IMAGE_NAME':'$IMAGE_TAG'"' k8s/deployment.yaml

                      git add k8s/deployment.yaml
                      git commit -m "Update image to $IMAGE_TAG"
                      git push origin main
                    '''
                }
            }
        }
    }
}