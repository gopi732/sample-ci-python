pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Clean before build
                cleanWs()
                // We need to explicitly checkout from SCM here
                checkout scm
            }
        }
        stage ('Install dependencies') {
            steps {
                sh 'pip install -r requirements.txt && pip install -e .'
            }
        }
        stage ('Test & SonarQube Analysis') {
	    environment {
		scannerHome = tool 'SonarQube Scanner'
	    }
            steps {
                echo "Unit Testing"
                sh 'python3 -m pytest'
                withSonarQubeEnv('Sonar') {
                    sh '${scannerHome}/bin/sonar-scanner \
                    -D sonar.projectKey=Test \
                    -D sonar.python.coverage.reportPaths=coverage.xml'	
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
                   serverId: 'admin',
                   spec: '''{
                          "files" :[
                            {
                               "pattern": "coverage/",
                               "target": "Test/",
                               "recursive": "false"
                            }
                          ]
                    }'''
                )
            }
        }    
    }
}
