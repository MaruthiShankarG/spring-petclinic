pipeline {
    agent any

    environment {
        // Example of adding environment variables if needed
        DOCKER_REPO = "maruthigs"  // Replace with your actual Docker repo
        K8S_NAMESPACE = "your-k8s-namespace"  // Kubernetes namespace to deploy to
    }

    stages {
        stage('Build') {
            steps {
                script {
                    if (fileExists('pom.xml')) {
                        sh 'mvn clean test -Dtest=!PostgresIntegrationTests'
                    } else {
                        echo 'No Maven project found'
                    }
                }
            }
        }
        stage('Test') {
            steps {
               sh 'mvn clean test -Dtest=!PostgresIntegrationTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                  sh 'docker build -t maruthigs/sprint-petclinic:latest")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.push("your-docker-repo/sprint-petclinic:latest")
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
