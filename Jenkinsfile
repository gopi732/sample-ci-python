// Declarative pipeline
pipeline {
    agent { dockerfile true} 
    environment {   
        http_proxy = 'http://127.0.0.1:3128/'
        https_proxy = 'http://127.0.0.1:3128/'
        ftp_proxy = 'http://127.0.0.1:3128/'
        socks_proxy = 'socks://127.0.0.1:3128/'     
    }
    stages {
        stage ('Test') {
            steps {
                sh 'python3 -m pytest'       
            }
        }
        stage ('Archive artifacts') {
            steps {
                archiveArtifacts artifacts: 'coverage/'
            }
        }
    }
}

