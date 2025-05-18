# 1. Image de base
FROM python:3.11-slim

# 2. Répertoire de travail dans le conteneur
WORKDIR /app

# 3. Copier les dépendances

# 5. Copier les fichiers de ton projet
COPY . . 
RUN pip install --no-cache-dir -r requirements.txt
# 6. Exposer le port utilisé par Django
EXPOSE 8000

# 7. Commande de lancement
CMD ["python3", "manage.py", "runserver" ,"172.17.0.1:8000"]