pipeline {
  agent none
  environment {   
        http_proxy = 'http://127.0.0.1:3128/'
        https_proxy = 'http://127.0.0.1:3128/'
        ftp_proxy = 'http://127.0.0.1:3128/'
        socks_proxy = 'socks://127.0.0.1:3128/'     
    }
  options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
  }
  stages {
      stage('CleanUp WorkSpace') {
	  agent { 
	      label 'slave'
	  }
          steps {
              // Clean before build
              cleanWs()
              // We need to explicitly checkout from SCM here
              checkout scm
              echo "Building ${env.JOB_NAME}..."
          }
	  post {
              // Clean after build
              always {
		 echo "Clone Code for GirHub Repository Succeeded"
              }
          }
      }	  
      stage('Build & Test') {
         agent {
	     dockerfile {
      	        filename 'Dockerfile'
   	        label 'slave'
	     }	        
	 }
	 steps {
	      sh 'python3 -m pytest'	 
	 }
	 post {
	      always {
		   archiveArtifacts artifacts: 'coverage/'
		   echo "Build Docker Image and test Conatainer and stop & delete Conatainer Succeeded"   
      	      }
	 }
      }	 
      stage('Code Analysis') {
	  agent {
     	       label 'slave'
    	  }
	  environment {
	       scannerHome = tool 'SonarQube Scanner'
	  }
	  steps {
	      withSonarQubeEnv('Sonar') {
		   sh '${scannerHome}/bin/sonar-scanner \
		      -D sonar.projectKey=CI-Docker \
		      -D sonar.python.coverage.reportPaths=coverage.xml'
	      }
          }
	  post {
	     always {
		   echo "Integration and reports send to sonarqube Succeeded"
	     }
	  }
      }
      stage('Deploy Atrifacts') {
	  agent {
     	       label 'slave'
    	  }
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
	  post {
	     always {
		   echo "Deploy Artifacts Jfrog Succeeded"
	     }
	  }
      }
   }
}
