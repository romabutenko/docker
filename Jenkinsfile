//# telecc/docker-example-1.11.2

pipeline {
   agent any

    options {
        disableConcurrentBuilds()
    }

    environment {
        DOCKER_REPO_URL             = "https://tc-dockerhub.telecontact.ru/v2/"
        DOCKER_REPO_credentialsId   = 'buildmaker_tcdockerhub'
        DOCKER_REGISTRY_MIRROR      = 'tc-dockerhub.telecontact.ru/mirror/'
        DOCKER_RELEASE_REPO         = 'tc-dockerhub.telecontact.ru/'
        COMPOSE_FILE                = 'docker-compose.yml:docker-compose.build.yml'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    withDockerRegistry([
                        credentialsId: "${DOCKER_REPO_credentialsId}",
                        url: "${DOCKER_REPO_URL}",
                    ]) {
                        sh 'touch .env'
                        sh 'make'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    withDockerRegistry([
                        credentialsId: "$DOCKER_REPO_credentialsId",
                        url: "$DOCKER_REPO_URL",
                    ]) {
                        sh 'echo "TODO: Warning! Test not found"'
                    }
                }
            }
        }
        stage('Release') {
            steps {
                script {
                    withDockerRegistry([credentialsId: "$DOCKER_REPO_credentialsId", url: "$DOCKER_REPO_URL" ]) {
                        sh 'make release'
                    }
                }
            }
        }
        stage('Clenup') {
            steps {
                script {
                    sh 'make clean'
                }
            }
        }
    }
}