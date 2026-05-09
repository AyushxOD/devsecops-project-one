# DevSecOps Project

A production-ready Node.js Express API with integrated security scanning and CI/CD pipeline.

## Features

- **Express API** with `/health` and `/data` endpoints
- **Docker** multi-stage build for optimized production images
- **Security Scanning** via Trivy (filesystem & container images)
- **SonarCloud** code quality analysis
- **AWS ECR** for container image storage

## Quick Start

```bash
# Install dependencies
npm install

# Run locally
npm start

# Docker
docker compose up -d
```

## Project Structure

```
├── index.js          # Express application
├── package.json      # Dependencies
├── Dockerfile        # Multi-stage Docker build
├── docker-compose.yml
└── terraform/        # AWS infrastructure
    ├── provider.tf
    └── main.tf       # ECR repository
```

## Security Pipeline

1. **Trivy FS Scan** - Scans codebase for vulnerabilities
2. **SonarCloud** - Code quality and security analysis
3. **Docker Build** - Builds production image
4. **Trivy Image Scan** - Scans container image
5. **Push to ECR** - Pushes to Amazon ECR with lifecycle policy (keeps last 5 versions)