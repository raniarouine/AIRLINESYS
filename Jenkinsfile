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
           
             withSonarQubeEnv(credentialsId: 'sonar',installationName: 'sonar') {

		        sh ' sonar-scanner  '        
                 }                 
             }
        }
        stage('Fin') {
            steps {
                echo ' Pipeline terminé avec succès !'
            }
        }
    }
}