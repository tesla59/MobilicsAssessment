pipeline {
    agent any
    
    tools {
        go 'go1.18'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/tesla59/go-app.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'go build -o my-app'
            }
        }
        
        stage('Deploy') {
            steps {
                withAWS(credentials: 'aws-credentials') {
                    sh 'aws configure set aws_access_key_id <accesskey>'
                    sh 'aws configure set aws_secret_access_key <secretkey>'
                    sh 'aws configure set region <awsregion>'
                    sh 'aws ec2 describe-instances --instance-ids <ec2instance>'

                    sh 'scp -i /home/ubuntu/key.pem my-app ubuntu@instance-ip:/home/ubuntu/my-app'
                    
                    sh 'ssh -i /home/ubuntu/key.pem ubuntu@instance-ip "sudo systemctl restart my-app"'
                }
            }
        }
    }
}
