pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')  // Reference the Access Key ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')  // Reference the Secret Access Key
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Check out the Terraform code from the Git repository
                git branch: 'main', url: 'https://github.com/shashank8617/test.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform and set up backend configuration
                    sh '''
                        terraform init \
                        -backend-config="bucket=my-terraform-state-bucket" \
                        -backend-config="key=terraform.tfstate" \
                        -backend-config="region=ap-south-1" \
                        -backend-config="dynamodb_table=terraform-locks"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Generate a Terraform execution plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform plan to provision resources
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after execution
            cleanWs()
        }
        success {
            echo 'Terraform execution completed successfully!'
        }
        failure {
            echo 'Terraform execution failed.'
        }
    }
}
