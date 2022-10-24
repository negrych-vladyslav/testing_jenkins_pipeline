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
    }

    stages {

    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }

    stage('Pushing to ECR') {
     steps{
         script {
			docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) {
                    	dockerImage.push()
                	}
         }
        }
      }

    stage('Deploy') {
    steps{
     sh "export TF_VAR_region='${AWS_DEFAULT_REGION}' && export TF_VAR_access_key='${AWS_ACCESS_KEY_ID}' && export TF_VAR_secret_key='${AWS_SECRET_ACCESS_KEY}' && terraform apply"

       }
      }
   }
 }
