pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "microservices-testing"
        DOCKER_CONTAINER = "microservices-container"
        DOCKER_PORT = "8081"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/AnzZamAdl/microservices-testing-examples.git'
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    sh 'mvn clean install'
                }
            }
        }
        
        stage('OWASP Dependency Check'){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }

        stage('Run Tests') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-login', toolName: 'docker'){
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh """
                        docker stop ${DOCKER_CONTAINER} || true
                        docker rm ${DOCKER_CONTAINER} || true
                    """
                    
                    // Run new container on port 8081
                    withDockerRegistry(credentialsId: 'docker-login', toolName: 'docker'){
                        sh """
                            docker run -d -p ${DOCKER_PORT}:8080 --name ${DOCKER_CONTAINER} ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build and Deployment Successful!"
        }
        failure {
            echo "Build or Deployment Failed!"
        }
    }
}
