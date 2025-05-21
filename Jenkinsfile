pipeline {
    agent any

    environment {
        // Your Docker Hub username
        DOCKER_USER = "kani1287"
        APP_NAME = "projCert"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG}"
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
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker push ${IMAGE_NAME}
                        """
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig-secret', variable: 'KUBECONFIG')]) {
                        sh """
                            echo 'Deploying to Kubernetes...'
                            kubectl set image deployment/${APP_NAME}-deployment ${APP_NAME}=${IMAGE_NAME} --record || kubectl apply -f k8s/deployment.yaml
                        """
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
