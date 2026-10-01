# DevOps Lab

A production-style DevOps project built to practice the full application delivery lifecycle:

```text
Code
  ↓
Git / GitHub
  ↓
CI
  ↓
Docker
  ↓
Container Registry
  ↓
Terraform
  ↓
AWS Infrastructure
  ↓
Kubernetes
  ↓
Monitoring / Observability
```

## Project

The workload is a small FastAPI service with:

- `GET /`
- `GET /health`
- `GET /version`

The application itself is intentionally simple. The main focus of the project is the infrastructure, automation, deployment, and operational tooling around it.

## Current Progress

### Application

- FastAPI service
- isolated Python environment
- automated tests with pytest

### Containers

- Dockerfile
- Docker Compose
- container health check
- application image tested locally

### CI / Image Publishing

- GitHub Actions runs tests on pushes and pull requests
- Docker image is automatically built after successful tests
- images are tagged with `latest` and the Git commit ID
- images are published to GitHub Container Registry

```text
git push
   ↓
pytest
   ↓
Docker build
   ↓
ghcr.io/alphakoder7/devops-lab-api
```

### Infrastructure as Code

AWS infrastructure is managed using Terraform.

Current infrastructure:

```text
AWS
└── VPC
    ├── Public Subnet A
    ├── Public Subnet B
    ├── Internet Gateway
    ├── Route Table
    └── EC2 Platform Node
```

The EC2 instance:

- runs Amazon Linux 2023
- is provisioned by Terraform
- uses an IAM role
- is managed through AWS Systems Manager
- does not require SSH port 22 to be exposed publicly

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── ci.yaml
├── app/
│   ├── __init__.py
│   ├── main.py
│   └── requirements.txt
├── infra/
│   └── terraform/
│       ├── compute.tf
│       ├── main.tf
│       ├── providers.tf
│       └── .terraform.lock.hcl
├── tests/
│   └── test_api.py
├── .dockerignore
├── .gitignore
├── compose.yaml
├── Dockerfile
├── requirements-dev.txt
└── README.md
```

## Current Stage

```text
Foundation        ✅
Linux / Git       ✅
Containers        ✅
CI / Registry     ✅
AWS / Terraform   🚧
Kubernetes        ⬜
Observability     ⬜
Final automation  ⬜
```

The current AWS networking and compute infrastructure is working.

Next step:

**Prepare the AWS platform node and run Kubernetes on it.**

## End Goal

The finished project should support a workflow similar to:

```text
code change
   ↓
git push
   ↓
automated tests
   ↓
container image build
   ↓
container registry
   ↓
automated deployment
   ↓
Kubernetes
   ↓
metrics / logs / alerts
```

The final lab will also be used to practice deployment failures, troubleshooting, recovery, and rollback.
