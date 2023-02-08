pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                
                git url: 'https://github.com/AmrGomaa96/projects' ,branch: 'main'
                sh "cd terraform-pro"

          }
        }
        
        stage ("terraform init") {
            steps {
                
                sh "ls"
                sh "pwd"
            }
        }
    }
}
