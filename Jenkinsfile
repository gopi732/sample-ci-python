pipeline {
   agent { dockerfile true }
   environment {
	http_proxy = 'http://127.0.0.1:3128/'
	https_proxy = 'http://127.0.0.1:3128/'
	ftp_proxy = 'http://127.0.0.1:3128/'
	socks_proxy = 'socks://127.0.0.1:3128/'
   }
   stages {
       stage('test') {
           steps {
               sh 'python3 -m pytest'
            }
	}
        stage ('Test & SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('Sonar') {
                    sh '${scannerHome}/bin/sonar-scanner \
                    -D sonar.projectKey=CI-Docker'	
                }
            }
        }
        stage ('Archive artifacts') {
            steps {
                archiveArtifacts artifacts: 'coverage/'
            }
        }
        stage ('Publish Artifactory') {
            steps {
                rtUpload (
                    serverId: 'JFrog',
                    spec: '''{
                        "files" :[
                            {
                                "pattern": "/coverage",
                                "target": "CI-Docker/",
                                "recursive": "false"
                            }
                        ]
                    }'''
	            )
	        }
        }
    }	
}
