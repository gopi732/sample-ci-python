pipeline {
  agent {
	label 'slave'
  }
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
      stage('CleanUp WorkSpace & Git Checkout') {
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
   	        reuseNode true
	     }	        
	 }
	 steps {
	      sh 'python3 -m pytest'
	      sh 'python3 -m coverage xml -o coverage/coverage.xml'	 
	 }
	 post {
	      always {
		   archiveArtifacts artifacts: 'coverage/'
		   echo "Build Docker Image and test Conatainer and stop & delete Conatainer Succeeded"   
      	      }
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
