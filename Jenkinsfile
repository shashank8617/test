pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id') // Ensure this matches your credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key') // Ensure this matches your credentials ID
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    git 'https://github.com/shashank8617/test.git' // Assuming this is public or GitHub token added
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
    post {
        always {
            cleanWs() // Clean workspace after the job
        }
    }
}
