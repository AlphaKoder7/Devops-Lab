import os

from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="DevOps Lab API")

APP_VERSION = os.getenv("APP_VERSION", "0.2.0")


@app.get("/")
def root():
    return {
        "service": "devops-lab-api",
        "message": "DevOps Lab service is running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/version")
def version():
    return {
        "version": APP_VERSION
    }


Instrumentator().instrument(app).expose(app)
