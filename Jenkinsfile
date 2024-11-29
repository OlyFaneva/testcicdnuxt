pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'votre-nom-image'
        DOCKER_TAG = "${GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Debug Workspace') {
            steps {
                script {
                    sh '''
                        echo "Répertoire de travail actuel :"
                        pwd
                        echo "\nContenu du répertoire :"
                        ls -la
                        echo "\nRecherche de package.json :"
                        find . -name "package.json"
                        echo "\nRecherche récursive :"
                        find . -type f -name "package.json"
                    '''
                }
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
                            echo 'Contenu du répertoire dans le conteneur :';
                            pwd;
                            ls -la /app;
                            
                            echo 'Recherche de package.json dans le conteneur :';
                            find /app -name 'package.json';
                            
                            if [ -f /app/package.json ]; then
                                echo 'package.json trouvé. Contenu :';
                                cat /app/package.json;
                                
                                yarn install;
                                yarn test;
                            else
                                echo 'ERREUR : package.json non trouvé';
                                exit 1;
                            fi
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