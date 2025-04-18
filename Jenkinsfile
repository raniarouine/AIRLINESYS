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
        
        stage('Collecte des fichiers statiques') {
            steps {
                sh '''
                    . ${VIRTUAL_ENV}/bin/activate
                    python manage.py collectstatic --noinput
                '''
            }
        }

        stage('Build Docker') {
            steps {
                sh 'docker build -t airlynes-app .'
            }
        }

        stage('Fin') {
            steps {
                echo '✅ Pipeline terminé avec succès !'
            }
        }
    }

    post {
        always {
            echo 'Nettoyage de l’environnement virtuel...'
            sh 'rm -rf ${VIRTUAL_ENV}'
        }

        success {
            echo 'Build réussi !'
        }

        failure {
            echo ' Le pipeline a échoué. Vérifie les logs.'
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
