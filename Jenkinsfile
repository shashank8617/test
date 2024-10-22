pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    // Checkout your Git repository
                    git 'https://github.com/shashank8617/test.git'
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Run Terraform Init
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform Plan
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Run Terraform Apply
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
    post {
        always {
            script {
                // Clean workspace after build
                cleanWs()
            }
        }
    }
}
