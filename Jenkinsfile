pipeline {
  agent {
	label 'slave'
  }	
  stages {
      stage('CleanUp WorkSpace & Git Checkout') {
          steps {
              // Clean before build
              cleanWs()
              // We need to explicitly checkout from SCM here
              checkout scm
          }
      }	  
      stage('Build & Test') {
         agent {
	     dockerfile {
      	        filename 'Dockerfile'
   	        reuseNode true
	     }	        
	 }
	 steps {
	      sh 'python3 -m pytest'	 
	 }
      }	 
      stage('Code Analysis') {
	  environment {
	       scannerHome = tool 'SonarQube Scanner'
	  }
	  steps {
	      withSonarQubeEnv('Sonar') {
		   sh '${scannerHome}/bin/sonar-scanner \
		      -D sonar.projectKey=CI-Docker \
		      -D sonar.python.coverage.reportPaths=*.js,*.html,*.json,*.css'
	      }
          }
      }
      stage('Deploy Atrifacts') {
	  steps {
	      rtUpload (
		 serverId: 'admin',
		 spec: '''{
 			"files" :[
			  {
		            "pattern": "coverage/",
		            "target": "CI-Docker",
	                    "recursive": "false"
	         	  }
		        ]
		 }'''
	     )
	 }
      }
   }
   post {
	 always {
	     echo 'I have finished'
	 }
         success { 
	     echo 'I succeeded!'
	 }
	 unstable {
	     echo 'I am unstable :/'
	 }
	 failure {
	     echo 'I failed :('
	 }
	 changed {
	     echo 'Things are different ...'
	 }	  
    }		 	  
}
