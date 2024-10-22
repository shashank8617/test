pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    git url: 'https://github.com/shashank8617/test.git'
                }
            }
        }
        stage('Your Next Stage') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                    script {
                        // Example command using AWS CLI
                        sh 'aws s3 ls' // Use AWS CLI commands here
                    }
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
