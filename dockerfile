# 1. Image de base
FROM python:3.11-slim

# Installer les dépendances système minimales
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Répertoire de travail dans le conteneur
WORKDIR /app


# 5. Copier les fichiers de ton projet

COPY . . 

RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000

# 7. Commande de lancement
CMD ["python3", "manage.py", "runserver" ,"0.0.0.0:8000"]
