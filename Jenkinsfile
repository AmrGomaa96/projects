pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                
                git url: 'https://github.com/AmrGomaa96/projects/tree/main/terraform-pro' ,branch: 'main'
                sh "cd terraform-pro"

          }
        }
        
        stage ("terraform init") {
            steps {
                
                sh "terraform init"
                sh "terraform plan"
            }
        }
    }
}