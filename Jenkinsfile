pipeline {
    agent any

    environment {
        VIRTUAL_ENV = "${WORKSPACE}/venv"
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
             //withSonarQubeEnv(credentialsId: 'sonar',installationName: 'sonar') {

		        //sh """
                   // . venv/bin/activate

                    //${tool 'sonar'}/bin/sonar-scanner
                //"""       
                // }                 
             }
        }
        
        stage('build docker-iamge') {
            steps {

                sh 'docker build -t managepython:1.$BUILD_NUMBER .'
          
            }
        }
        stage('Fin') {
            steps {
                echo ' Pipeline terminé avec succès !'
            }
        }
    }

}