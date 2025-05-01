pipeline {
    agent any

    environment {
        VIRTUAL_ENV = "${WORKSPACE}/venv"
        TRIVY_IMAGE = 'aquasec/trivy:latest'
        NIKTO_IMAGE = 'frapsoft/nikto:latest'
        DOCKER_IMAGE_NAME = 'app-django'
        DEPLOY_DIR = '.'
        IMAGE_NAME = "raniaiset/managepython"
        IMAGE_TAG = "1.${BUILD_NUMBER}"

    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main', url: 'https://github.com/raniarouine/AIRLINESYS.git'
            }
        }

        stage('Préparer l\'environnement Python') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Lancer les tests') {
            steps {
                sh '''
                    . venv/bin/activate

                    python manage.py test
                '''
            }
        } 
        stage("Quality code Test") {
            steps {
           echo 'rania'
             withSonarQubeEnv(credentialsId: 'sonar',installationName: 'sonar') {

		        sh """
                    . venv/bin/activate

                    ${tool 'sonar'}/bin/sonar-scanner
                """       
                 }                 
             }
        }
        stage('build docker-iamge') {
            steps {

                sh 'docker build -t managepython:1.$BUILD_NUMBER .'
          
            }
        }
        stage('run docker-container') {
            steps {
                sh 'docker run -d -p 8000:8000  --name managepython10_container managepython:1.$BUILD_NUMBER'
            }
        }
        

          stage('Tag Docker Image') {
            steps {
                 script {
                       sh "docker tag managepython:1.${BUILD_NUMBER} raniaiset/managepython:1.${BUILD_NUMBER}"
        }
    }
}
        stage('Run OWASP ZAP Scan') {
            steps {
                sh "  docker run --rm -u root -v ${env.WORKSPACE}:/zap/wrk:rw zaproxy/zap-stable zap-full-scan.py -t http://172.17.0.1:8000 -r zap_report.html -j -I"
            }
        }
	   stage('Publish ZAP Report') {
            steps {
                archiveArtifacts artifacts: 'zap_report.html', fingerprint: true
            }
        }


        stage('Deploy our image') { 

            steps { 
               script{

                  withDockerRegistry([credentialsId:"docker-hub", url:""]){
                                      sh ' docker push raniaiset/managepython:1.$BUILD_NUMBER '
                   
                } 

               }
	    }   
  
}

           stage('Démarrer l\'application avec Docker Compose') {
            steps {
                sh 'docker-compose up -d'
            }
        }
         stage('Scan de sécurité - Trivy') {
            steps {
                sh "docker run --rm ${TRIVY_IMAGE} image ${DOCKER_IMAGE_NAME}:latest"
            }
        }
           stage('Scan de sécurité - Nikto') {
            steps {
                // Attendre quelques secondes que le conteneur soit prêt
                sh '''
                    sleep 10
                    docker run --rm ${NIKTO_IMAGE} -host http://localhost:8011
                '''
            }
        }

        stage('Fin') {
            steps {
                echo ' Pipeline terminé avec succès !'
            }
        }
    }

}