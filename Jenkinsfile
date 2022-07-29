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
		      -D sonar.projectKey=CI-Docker \
		      -D sonar.python.coverage.reportPaths=/home/sai/workspace/Multibranch-Ci_master-ci-2/coverage/*.js,*.html,*.json,*.css'
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
		            "target": "CI-Docker",
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
