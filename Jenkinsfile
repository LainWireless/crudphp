pipeline {
    environment {
        IMAGEN = "lainwireless/crudphp:v1"
        LOGIN = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Construccion") {
                agent any
                stages {
                    stage('Clonacion') {
                        steps {
                            git branch:'main',url:'https://github.com/LainWireless/crudphp.git'
                        }
                    }
                    stage('BuildImage') {
                        steps {
                            script {
                                newApp = docker.build "$IMAGEN:latest"
                            }
                        }
                    }
                    stage('UploadImage') {
                        steps {
                            script {
                                docker.withRegistry( '', LOGIN ) {
                                    newApp.push()
                                }
                            }
                        }
                    }
                    stage('RemoveImage') {
                        steps {
                            sh "docker rmi $IMAGEN:latest"
                        }
                    }
                    stage ('SSH') {
                        steps{
                            sshagent(credentials : ['SSH_ROOT']) {
                                sh 'ssh -o StrictHostKeyChecking=no kaiser@ataraxia.ivanasir2.com wget https://raw.githubusercontent.com/LainWireless/crudphp/main/docker-compose.yaml -O docker-compose.yaml'
                                sh 'ssh -o StrictHostKeyChecking=no kaiser@ataraxia.ivanasir2.com  docker-compose up -d --force-recreate'
                            }
                        }
                    }
                }
            }           
        }
        post {
            always {
                mail to: 'ivanpicas88@gmail.com',
                subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
                body: "${env.BUILD_URL} has result ${currentBuild.result}"
            }
        }
}