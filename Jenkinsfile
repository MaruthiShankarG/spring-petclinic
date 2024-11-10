pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "maruthigs/spring-petclinic:latest"  // Docker image name
        K8S_NAMESPACE = "default"  // Kubernetes namespace
        K8S_DEPLOYMENT_FILE = "Deployment.yaml"  // Path to your Kubernetes deployment YAML file
     //   K8S_SERVICE_FILE = "k8s/spring-petclinic-service.yaml"  // Path to your Kubernetes service YAML file
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -l target/'
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    def jarExists = fileExists 'target/spring-petclinic-3.3.0-SNAPSHOT.jar'
                    if (jarExists) {
                        echo 'JAR file exists, proceeding with Docker build.'
                        sh 'docker build -t maruthigs/spring-petclinic:latest .'
                    } else {
                        error 'JAR file does not exist, build failed.'
                    }
                }
            }
        }
        stage('Push to Docker Hub') { 
            steps { withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKERHUB_PASSWORD')]) { 
                sh ''' echo $DOCKERHUB_PASSWORD | docker login -u maruthigs --password-stdin
                       docker push maruthigs/spring-petclinic:latest
                '''
                }
            }
        } 
        // New stage for Kubernetes deployment
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Set up Kubernetes credentials to access the cluster
                   sh "aws eks update-kubeconfig --name sample --region us-east-1"
                    // Apply the Kubernetes deployment and service YAML files
                    sh "kubectl apply -f ${K8S_DEPLOYMENT_FILE} -n ${K8S_NAMESPACE}"
                      
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Verify if the deployment was successful
                    sh "kubectl rollout status deployment/spring-petclinic-deployment -n ${K8S_NAMESPACE}"
                    // Check the status of the service
                    sh "kubectl get svc/spring-petclinic-service -n ${K8S_NAMESPACE}"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
