# 1. Image de base
FROM python:3.11-slim


RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app




COPY . . 

RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000


CMD ["python3", "manage.py", "runserver" ,"0.0.0.0:8000"]
