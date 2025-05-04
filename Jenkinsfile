pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'calculatorapp:latest'
        DOCKER_CREDENTIALS = 'docker-credentials'
    }

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/Justinino1/CalculatorApp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}").inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Ready to deploy: Run container or push image to registry if needed."
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
