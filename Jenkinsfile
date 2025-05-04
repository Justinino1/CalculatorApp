pipeline {
    agent any

    environment {
        IMAGE_NAME = 'calculatorapp'
        TAG = 'latest'
        CONTAINER_NAME = 'calculatorapp-container'
        DOCKERHUB_CREDENTIALS_ID = 'docker-credentials' 
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                echo "🔄 Checking out source code from GitHub..."
                git branch: 'main',
                    url: 'https://github.com/Justinino1/CalculatorApp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image ${IMAGE_NAME}:${TAG}..."
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    echo "🧪 Running Django tests inside Docker image..."
                    docker.image("${IMAGE_NAME}:${TAG}").inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    echo "📦 Deploying Docker container..."

                    sh '''
                        echo "🛑 Stopping existing container (if any)..."
                        docker stop ${CONTAINER_NAME} || true

                        echo "🗑️ Removing old container (if any)..."
                        docker rm ${CONTAINER_NAME} || true

                        echo "🚀 Starting new container..."
                        docker run -d -p 8000:8000 --name ${CONTAINER_NAME} ${IMAGE_NAME}:${TAG}
                    '''
                }
            }
        }

        /*
        stage('Push to DockerHub') {
            steps {
                echo "📤 Pushing image to DockerHub..."
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
        success {
            echo '✅ Deployment completed successfully!'
        }
        failure {
            echo '❌ Deployment failed. Please check logs.'
        }
        always {
            echo '🧹 Cleaning up workspace...'
            cleanWs()
        }
    }
}
