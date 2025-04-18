pipeline {
    agent any

    environment {
        VIRTUAL_ENV = "${WORKSPACE}/venv"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git 'https://github.com/raniarouine/AIRLINESYS.git'
            }
        }

        stage('Préparer l\'environnement Python') {
            steps {
                sh '''
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Lancer les tests') {
            steps {
                sh '''
                    source venv/bin/activate
                    python manage.py test
                '''
            }
        }

        stage('Fin') {
            steps {
                echo ' Pipeline terminé !'
            }
        }
    }
}
