pipeline {
    agent any

    environment {
        // Example of adding environment variables if needed
        DOCKER_REPO = "your-docker-repo"  // Replace with your actual Docker repo
        K8S_NAMESPACE = "your-k8s-namespace"  // Kubernetes namespace to deploy to
    }

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
