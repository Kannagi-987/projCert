pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kani1287/projcert"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKER_CREDS = 'docker-hub-creds'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig-secret'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Kannagi-987/projCert'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIALS_ID}", variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}
