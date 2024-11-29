pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ProjetNuxt'
        DOCKER_TAG = "${GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker', url: '']) {
                    sh """
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }

        stage('Deploy to VPS') {
            steps {
                script {
                    sh """
                        sshpass -p "${SSH_CREDENTIALS_PSW}" \
                        ssh -o StrictHostKeyChecking=no \
                        ${root}@89.116.111.200 \
                        "
                            docker pull ${DOCKER_IMAGE}:${DOCKER_TAG};
                            docker stop my-app || true;
                            docker rm my-app || true;
                            docker run -d --name my-app -p 80:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        "
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                sh '''
                    echo "Nettoyage des ressources Docker"
                    docker system prune -f
                '''
            }
        }
    }
}