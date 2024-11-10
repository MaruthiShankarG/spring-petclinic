pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
        DOCKER_IMAGE = "maruthigs/spring-petclinic:latest"  // Docker image name
        K8S_NAMESPACE = "default"  // Kubernetes namespace
        K8S_DEPLOYMENT_FILE = "Deployment.yaml"  // Path to your Kubernetes deployment YAML file
        // K8S_SERVICE_FILE = "k8s/spring-petclinic-service.yaml"  // Path to your Kubernetes service YAML file
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -l target/'  // Ensure the JAR file exists in the target directory
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Check if the JAR file exists before building the Docker image
                    def jarExists = fileExists 'target/spring-petclinic-3.3.0-SNAPSHOT.jar'
                    if (jarExists) {
                        echo 'JAR file exists, proceeding with Docker build.'
                        sh 'docker build -t maruthigs/spring-petclinic:latest .'  // Build Docker image
                    } else {
                        error 'JAR file does not exist, build failed.'  // Exit if JAR doesn't exist
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKERHUB_PASSWORD')]) {
                    sh ''' 
                    echo $DOCKERHUB_PASSWORD | docker login -u maruthigs --password-stdin
                    docker push maruthigs/spring-petclinic:latest
                    '''
                }
            }
        }

        // Kubernetes deployment stage
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update kubeconfig for AWS EKS cluster access
                    sh "aws eks update-kubeconfig --name sample --region us-east-1"  // Replace with your cluster name and region
                    // Apply Kubernetes deployment YAML file
                    sh "kubectl apply -f ${K8S_DEPLOYMENT_FILE} -n ${K8S_NAMESPACE}"
                    // If you have a service YAML, you can uncomment the line below:
                    // sh "kubectl apply -f ${K8S_SERVICE_FILE} -n ${K8S_NAMESPACE}"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Verify if the deployment was successful
                    sh "kubectl rollout status deployment/spring-petclinic-deployment -n ${K8S_NAMESPACE}"
                    // Check the status of the service (if defined)
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
