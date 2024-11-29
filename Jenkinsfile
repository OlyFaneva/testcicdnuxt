pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'votre-nom-image'
        DOCKER_TAG = "${GIT_COMMIT.take(7)}"
        SSH_CREDENTIALS = credentials('ssh-credentials')
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies and Test') {
            steps {
                script {
                    sh '''
                        docker run --rm \
                        -v $PWD:/app \
                        -w /app \
                        node:18-alpine \
                        sh -c "
                            ls -l /app;
                            cp /app/package.json /tmp/;
                            ls -l /tmp;
                            
                            if [ ! -f /tmp/package.json ]; then
                                echo 'Error: package.json not found';
                                exit 1;
                            fi;
                            
                            yarn install;
                            yarn test
                        "
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub', url: '']) {
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
                        ${SSH_CREDENTIALS_USR}@89.116.111.200 \
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
}