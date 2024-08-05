pipeline {
    agent any

    environment {
        YC_CLOUD_ID = 'b1gpl53sdobvpahkcboc'
        YC_FOLDER_ID = 'b1ge0llpg1gnn3hpv1n4'
        YC_SERVICE_ACCOUNT_KEY = credentials('AQVN2bRnQ6dBa5hvYtf_8475j4CvS8tETIcYkzfd')
        DOCKER_IMAGE = 'aamitv/project12'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/AAM-ITV/project12.git'
            }
        }
        
        stage('Terraform Init & Apply') {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Setup Build Node') {
            steps {
                script {
                    dir('ansible') {
                        sh 'ansible-playbook -i inventory build_node.yml'
                    }
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    dir('app') {
                        sh './gradlew build'
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Prod Node') {
            steps {
                script {
                    dir('ansible') {
                        sh 'ansible-playbook -i inventory deploy.yml'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
