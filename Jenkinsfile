pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = 'AKIARPL2F63JJFZSNZCX' // Replace with your actual Access Key ID
        AWS_SECRET_ACCESS_KEY = 'v7vOeddDwkehDfoKKLDgxe3wjvrmg4+tyDU9IWb+' // Replace with your actual Secret Access Key
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    // Clone your repository using Git
                    git url: 'https://github.com/shashank8617/test.git'
                }
            }
        }
        // Add other stages as needed
        stage('Your Next Stage') {
            steps {
                script {
                    // Example command using AWS CLI
                    sh 'aws s3 ls' // Use AWS CLI commands here
                }
            }
        }
    }
    post {
        always {
            script {
                cleanWs() // Clean up the workspace
            }
        }
    }
}
