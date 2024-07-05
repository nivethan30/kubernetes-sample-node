pipeline {
    agent any

    environment {
        // Define your Docker registry credentials as environment variables
        registryCredentials = 'docker-credential'
        dockerImageTag = "nivethan30/sample-node:v1"
        storageDir = "/home/m1/sample-node"
        kubeconfig = "kube-config"
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
                    docker.withRegistry('https://registry.hub.docker.com', registryCredentials) {
                        def dockerImage = docker.image(dockerImageTag)
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy Node Application'){
            steps{
                script{
                    withCredentials([File(credentialsId: kubeconfig, variable: 'kube' )]){
                        sh '''
                        kubectl --kubeconfig=${kube} apply -f ${storageDir}/kubernetes/sample-node-deployment.yaml
                        '''
                    }
                }
            }
        }

        stage('Expose Node Application Service'){
            steps{
                script{
                    withCredentials([File(credentialsId: kubeconfig, variable: 'kube' )]){
                        sh '''
                        kubectl --kubeconfig=${kube} apply -f ${storageDir}/kubernetes/sample-node-service.yaml
                        '''
                    }
                }
            }
        }
    }

    post{
        success{
            echo "Pipeline Completed Successfully"
        }
        failure{
            echo 'Pipeline Failed'
        }
    }
}
