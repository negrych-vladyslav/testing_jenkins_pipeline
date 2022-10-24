#!groovy

node {
    def app
    def md5Name = (sh (script: 'echo -n "${BRANCH_NAME}" | md5sum | awk \'{print $1}\'', returnStdout: true)).trim()

    env.PROJECT_NAME = 'brands-data-api'

    try {
        if (env.CHANGE_TITLE) {
            stage('Check PR title') {
                echo "PR title: ${CHANGE_TITLE}"
                def matcher =  CHANGE_TITLE =~ /^(\[((.*)KLIC-(\d*)|Hotfix)\] (.{5,})|(Pre-release|Release)(.*))$/
                if (matcher && matcher[0][1]) {
                    echo "PR title is valid"
                } else {
                    error("PR title is not valid")
                }
            }
        } else {
            lock(resource: "${PROJECT_NAME}-${BRANCH_NAME}-deploy") {
                stage('Clone repository') {
                    checkout scm
                }

                stage ('Copy GitHub NPM registry') {
                    sh "cp -a /var/lib/jenkins/klickly_configs/.npmrc ./.npmrc"
                }

                stage('Build image') {
                    app = docker.build("${PROJECT_NAME}-${md5Name}-container")
                }

                app.inside {
                    stage('Tests') {
                        parallel (
                            'Lints': {
                                sh 'npm run test:eslint'
                            },
                            'Unit tests': {
                                sh 'npm run test:mocha'
                            }
                        )
                    }
                }

                stage('Login and push to ECR') {
                    sh "eval \$(aws ecr get-login --registry-ids 375760062156 --region us-west-2 --no-include-email)"
                    sh "docker tag ${PROJECT_NAME}-${md5Name}-container 375760062156.dkr.ecr.us-west-2.amazonaws.com/brands-data-api:${BRANCH_NAME}"
                    sh "docker push 375760062156.dkr.ecr.us-west-2.amazonaws.com/brands-data-api:${BRANCH_NAME}"
                }
    catch (exc) {
        echo "I failed, ${exc}"
        currentBuild.result = 'FAILURE'
    }
    finally {
        echo "I am ${currentBuild.result}. One way or another, I have finished";
        deleteDir()
    }
}
