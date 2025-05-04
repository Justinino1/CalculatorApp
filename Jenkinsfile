pipeline {
    agent any

    environment {
        IMAGE_NAME = 'calculatorapp'
        TAG = 'latest'
        DOCKERHUB_CREDENTIALS_ID = 'docker-credentials' 
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Justinino1/CalculatorApp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    docker.image("${IMAGE_NAME}:${TAG}").inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh "docker rm -f ${IMAGE_NAME} || true" // Stop existing container if exists
                    sh "docker run -d -p 8000:8000 --name ${IMAGE_NAME} ${IMAGE_NAME}:${TAG}"
                }
            }
        }

        // Optional: Push to DockerHub
        /*
        stage('Push to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", url: '') {
                    script {
                        docker.image("${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }
        */
    }

    post {
        always {
            cleanWs()
        }
    }
}
