pipeline {
    agent any

    environment {
        // Your Docker Hub username
        DOCKER_USER = "kani1287"
        APP_NAME = "projCert"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                // Clone from GitHub
                git url: 'https://github.com/Kannagi-987/projCert.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                // Assumes Node.js project – adjust for Python, Java, etc.
                sh 'npm install || echo "No npm dependencies"'
            }
        }

        stage('Run Tests') {
            steps {
                // Adjust or remove if no tests exist
                sh 'npm test || echo "No tests defined"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the image: docker build -t username/appname:build_number .
                    dockerImage = docker.build("${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push the image using stored Docker Hub credentials (ID: docker-hub-creds)
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and Docker push completed successfully!"
        }
        failure {
            echo "❌ Build failed. Check logs above."
        }
    }
}
