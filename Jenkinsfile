pipeline {
  agent none
  stages {
      stage('Build') {
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
		      -D sonar.projectKey=CI-Docker'
	      }
          }
	  post {
	     always {
		   echo "I Succeeded"
	     }
	  }
      }
      stage('Deploy Atrifacts') {
	  agent {
     	       label 'slave'
    	  }
	  steps {
	      rtUpload (
		 serverId: 'JFrog',
		 spec: '''{
 			"files" :[
			  {
		            "target": "pythonapp/",
	                    "recursive": "false"
	         	  }
		        ]
		 }'''
	     )
	 }
	  post {
	     always {
		   echo "I Succeeded"
	     }
	  }
      }
   }
}
