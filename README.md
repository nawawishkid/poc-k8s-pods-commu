# PoC: K8S Pod-to-Pod Communication (REST API)

## Overview

This project PoC to demonstrate how 2 Pods in the same namespace can communicate with each other via using Service resource. It consists of two simple FastAPI applications that communicate with each other via their REST APIs.

## Applications

- App1 (Sender): Receives messages and forwards them to App2.
- App2 (Receiver): Receives messages from App1.

## Prerequisites

- Docker
- Kubernetes (with kubectl configured)
- Make (optional for using the provided Makefile)

## Getting Started

### Build and Deploy

You can use the provided Makefile for easy building and deploying:

**Build Docker Images:**

```bash
make build
```

**Deploy to Kubernetes:**

```bash
make deploy
```

**Port Forwarding**

Forward the port from app1-service to access it locally:

```bash
make port-forward
```

**Testing**

Test the connection between App1 and App2:

```bash
make test
```

**Clean Up**

To clean up and remove the Kubernetes deployments and services:

```bash
make clean
```

## Directory Structure

- `app1` - Source code for App1.
- `app2` - Source code for App2.
- `app1/Dockerfile` and `app2/Dockerfile` - Dockerfiles for building the application images.
- `k8s` - Kubernetes configuration files (app1-deploy.yaml, app2-deploy.yaml, etc.).
- `Makefile` - Automates the build and deploy process.
