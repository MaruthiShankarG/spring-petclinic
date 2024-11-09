pipeline {
    agent any
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
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                    echo $DOCKERHUB_PASSWORD | docker login -u gmaruthishankar1@gmail.com --password-stdin
                    docker push yourdockerhubusername/spring-petclinic:latest
                    '''
                }
            }
        } 
    }
}
