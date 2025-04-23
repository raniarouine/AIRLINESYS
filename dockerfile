# 1. Image de base
FROM python:3.11-slim

# 2. Répertoire de travail dans le conteneur
WORKDIR /app

# 3. Copier les dépendances
COPY requirements.txt .

# 4. Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copier les fichiers de ton projet
COPY manage.py .
COPY data/db.sqlite3 .
COPY django_arms/ ./django_arms/
COPY armsApp/ ./armsApp/
COPY static/ ./static/
COPY media/ ./media/

# 6. Exposer le port utilisé par Django
EXPOSE 8000

# 7. Commande de lancement
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]