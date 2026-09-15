import os

from fastapi import FastAPI

app = FastAPI(title="DevOps Lab API")

APP_VERSION = os.getenv("APP_VERSION", "0.1.0")


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
