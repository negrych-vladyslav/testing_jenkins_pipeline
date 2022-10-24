pipeline {
    agent any

    environment {
        IMAGE_REPO_NAME = "node-app"
        IMAGE_TAG = "${env.BUILD_ID}"
    stages {

    // Building Docker images
        stage('Building image') {
            steps{
                script {
                      dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                 }
               }
             }
          }
      }
  }
