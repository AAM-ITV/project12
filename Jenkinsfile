pipeline {
    agent none // Не используем агент на уровне pipeline

    environment {
        DOCKER_IMAGE = 'aamitv/myapp:latest' // Ваш Docker Hub репозиторий
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // ID учетных данных в Jenkins
        SSH_KEY_PATH = '/var/lib/jenkins/.ssh/id_rsa' // Путь к вашему приватному SSH ключу в контейнере Jenkins
        TERRAFORM_VERSION = 'Terraform' // Укажите имя, которое вы задали в настройках
        ANSIBLE_VERSION = 'Ansible'
    }

    stages {
        stage('Checkout') {
            agent { label 'master' } // Указываем, что этот шаг выполняется на Jenkins Master
            steps {
                git 'https://github.com/AAM-ITV/project12.git'
            }
        }
        stage('Check Terraform Version') {
            agent { label 'master' }
            tools {
                terraform "${env.TERRAFORM_VERSION}"
            }
            steps {
                script {
                    sh 'terraform --version'
                }
            }
        }

        stage('Terraform Init & Apply') {
            agent { label 'master' }
            tools {
                terraform "${env.TERRAFORM_VERSION}"
            }
            steps {
                script {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    
                }
            }
        }
        
        stage('Generate Ansible Inventory') {
            agent { label 'master' }
            steps {
                script {
                    def buildNodeIp = sh(script: 'terraform output -raw build_node_ip', returnStdout: true).trim()
                    def prodNodeIp = sh(script: 'terraform output -raw prod_node_ip', returnStdout: true).trim()

                    writeFile file: 'inventory', text: """
[build_node]
${buildNodeIp} ansible_user=jenkins ansible_ssh_private_key_file=${SSH_KEY_PATH} ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[prod_node]
${prodNodeIp} ansible_user=jenkins ansible_ssh_private_key_file=${SSH_KEY_PATH} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
                    """
                }
            }
        }

        stage('Setup Build Node') {
            agent { label 'master' } // Настройка билдовой ноды выполняется на Jenkins Master
             tools {
                ansible "${env.ANSIBLE_VERSION}"
             }
            steps {
                script {
                        sh 'ansible-playbook -i inventory ansible-build_node.yml --private-key=${SSH_KEY_PATH}'
                }
            }
        }

        

        stage('Setup Prod Node') {
            agent { label 'master' } // Настройка продовой ноды выполняется на Jenkins Master
            tools {
                ansible "${env.ANSIBLE_VERSION}"
             }
            steps {
                script {
                        sh 'ansible-playbook -i inventory ansible-prod_node.yml --private-key=${SSH_KEY_PATH}'
                    
                }
            }
        }
    }
    post {
        always {
            cleanWs() // Очистка рабочего пространства после выполнения пайплайна
        }
    }
}
