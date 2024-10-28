pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    if (fileExists('pom.xml')) {
                        sh 'mvn clean install'
                    } else {
                        echo 'No Maven project found'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("your-docker-repo/sprint-petclinic:latest")
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                kubernetesDeploy(configs: 'deployment.yaml', enableConfigSubstitution: true)
            }
        }
    }
}
