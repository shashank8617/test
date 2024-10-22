pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }
    stages {
        stage('Checkout Code') {
            steps {
                // Checkout your Git repository
                git 'https://github.com/shashank8617/test.git'
            }
        }
        stage('Terraform Init') {
            steps {
                // Run Terraform Init
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                // Run Terraform Plan
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                // Run Terraform Apply
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
    post {
        always {
            // Clean workspace after build
            cleanWs()
        }
    }
}
