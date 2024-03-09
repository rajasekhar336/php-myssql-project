pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'clone'
            }
        }
        stage('Docker build') {
            steps {
                script {
                    app = docker.build('rajack')
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Empty'
            }
        }
        stage('Docker push to ECR') {
            steps {
                script {
                    docker.withRegistry('https://471112907684.dkr.ecr.ap-south-1.amazonaws.com/rajack', 'ecr:ap-south-1:AWS_CRED') {
                    app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
        stage('Modify Deployment') {
            steps {
                script {
                    // Replace the image tag in the deployment file
                    sh "sed -i 's|image:.*rajack:latest|image: 471112907684.dkr.ecr.ap-south-1.amazonaws.com/rajack:${env.BUILD_NUMBER}|g' deployment.yaml"
		    }
            }
        }
        
        stage('Integrate Jenkins with EKS Cluster and Deploy') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'my-awesome-cluster', contextName: '', credentialsId: 'KUBERNETES', namespace: 'prod', serverUrl: 'https://89625682B399FC3094B5C4EFA8843FEB.gr7.ap-south-1.eks.amazonaws.com']]) {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}

