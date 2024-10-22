pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                // Ensure you're specifying the correct branch
                git branch: 'main', url: 'https://github.com/shashank8617/test.git'
            }
        }

        stage('Your Next Stage') {
            steps {
                echo 'Running your next stage...'
                // Add your build commands or steps here
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after job finishes
        }
    }
}
