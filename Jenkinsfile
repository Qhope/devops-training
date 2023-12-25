pipeline {
   agent none
   environment {
        NODE = "Build-server"
        PASS = credentials('pass')
        DOCKER_HUB = credentials('docker-pass')
    }

   stages {
    stage('Build Image') {
        agent {
            node {
                label "build-slave"
                customWorkspace "/Users/quanghop/Documents/devops/devops-training-$ENV/"
                }
            }
        environment {
            TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
        }
         steps {
            sh "echo $ENV"

            sh "docker --version"

            sh 'security unlock-keychain -p $PASS'

            sh 'echo "$DOCKER_HUB" | docker login -u quanghop --password-stdin'

            sh "docker build nodejs/. -t devops-training-nodejs-$ENV:latest --build-arg BUILD_ENV=$ENV -f nodejs/Dockerfile"

            // tag docker image
            sh "docker tag devops-training-nodejs-$ENV:latest quanghop/devops-training:$TAG"

            //push docker image to docker hub
            sh "docker push quanghop/devops-training:$TAG"

	        // remove docker image to reduce space on build server	
            sh "docker rmi -f quanghop/devops-training:$TAG"

           }
         
       }
	  stage ("Deploy ") {
	    agent {
        node {
            label "deploy-slave"
                customWorkspace  "/Users/quanghop/Documents/devops/devops-training-$ENV/"
            }
        }
        environment {
            TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
        }
	steps {
            sh 'security unlock-keychain -p $PASS'

            sh "sed -i '' 's/{tag}/$TAG/g' /Users/quanghop/Documents/devops/devops-training-$ENV/docker-compose.yaml"

            sh "sed -i '' 's/{env}/$ENV/g' /Users/quanghop/Documents/devops/devops-training-$ENV/docker-compose.yaml"
            
            sh "docker compose up -d"
        }      
       }
   }
    
}
