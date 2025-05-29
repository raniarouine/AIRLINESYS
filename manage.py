#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys
from prometheus_client import start_http_server, Counter, Histogram
import threading
import time
import random
import socket

# Prometheus metrics
REQUEST_COUNT = Counter('app_requests_total', 'Total number of requests')
REQUEST_LATENCY = Histogram('app_request_latency_seconds', 'Request latency')

def process_metrics():
    """Background thread to simulate and expose Prometheus metrics."""
    start_http_server(8000)  # Expose metrics on http://localhost:8000/metrics
    print("Prometheus metrics server started on port 8001")

    while True:
        REQUEST_COUNT.inc()
        with REQUEST_LATENCY.time():
            time.sleep(random.uniform(0.1, 0.9))
def start_server():
    # Create TCP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Allow reuse of address
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    # Bind to address and port
    sock.bind(('0.0.0.0', 8000))
    sock.listen(5)

    print("Server started on port 8080...")

    while True:
        conn, addr = sock.accept()
        print(f"Connection from {addr}")
        conn.sendall(b"Hello from server!")
        conn.close()
def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_arms.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    threading.Thread(target=process_metrics, daemon=True).start()
    main()
