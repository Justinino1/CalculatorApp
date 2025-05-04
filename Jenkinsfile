pipeline {
    agent any

    environment {
        IMAGE_NAME = 'calculatorapp'
        TAG = 'latest'
        DOCKERHUB_USERNAME = 'ishhod08'
        FULL_IMAGE_NAME = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}"
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
                    echo "🐳 Building Docker image ${FULL_IMAGE_NAME}:${TAG}..."
                    docker.build("${FULL_IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    docker.image("${FULL_IMAGE_NAME}:${TAG}").inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "📤 Pushing image to DockerHub..."
                withDockerRegistry(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", url: '') {
                    script {
                        docker.image("${FULL_IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    echo "🛑 Stopping existing container (if any)..."
                    sh "docker stop calculatorapp-container || true"

                    echo "🗑️ Removing old container (if any)..."
                    sh "docker rm calculatorapp-container || true"

                    echo "🚀 Starting new container..."
                    sh "docker run -d -p 8000:8000 --name calculatorapp-container ${FULL_IMAGE_NAME}:${TAG}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed.'
        }
    }
}
