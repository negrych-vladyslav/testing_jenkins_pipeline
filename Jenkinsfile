pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="075589242607"
        AWS_DEFAULT_REGION="eu-west-1"
	CLUSTER_NAME="ecs-cluster"
	SERVICE_NAME="ecs-service"
	TASK_DEFINITION_NAME="ecs-task"
	DESIRED_COUNT="1"
        IMAGE_REPO_NAME="node-app"
        IMAGE_TAG="${env.BUILD_ID}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
      AWS_ACCESS_KEY_ID = "AKIARDGLYJ3XVOFQYZIC"
      AWS_SECRET_ACCESS_KEY = "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"
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
