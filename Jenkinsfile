pipeline {
    agent any

    environment {
        // Define your Docker registry credentials as environment variables
        registryCredentials = credentials('docker-credential')
        dockerImageTag = "nivethan30/sample-node:v1"
        storageDir = "/home/m1/sample-node"
    }
    
    stages {
        stage('Checkout and Store Files') {
            steps {
                script {
                    // Ensure the directory exists, create it if it doesn't
                    sh "mkdir -p ${storageDir}"
                    
                    // Checkout code from SCM (Git)
                    checkout scm
                    
                    // Move files to the specific directory, preserving attributes
                    sh "rsync -av --exclude='.git/' ${env.WORKSPACE}/ ${storageDir}/"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Navigate to the directory with the Dockerfile
                    dir(storageDir) {
                        // Build the Docker image
                        def dockerImage = docker.build(dockerImageTag)
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to registry
                    docker.withRegistry('', registryCredentials) {
                        def dockerImage = docker.image(dockerImageTag)
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
