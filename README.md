# 🚀 DevSecOps Project One: Secure Cloud-Native API

A robust, enterprise-grade CI/CD pipeline featuring a containerized Express.js API, automated AWS infrastructure, and a "Shift-Left" security architecture.

---

## 🏗️ Architecture Overview

This project demonstrates a complete lifecycle from local development to a secured AWS production-ready registry.

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Application** | Node.js Express API | Hardened with `helmet` and `express-rate-limit` |
| **Infrastructure** | Terraform + AWS ECR | Infrastructure as Code with lifecycle policies |
| **Security** | SonarCloud + Trivy | SAST, container scanning, quality gates |
| **CI/CD** | GitHub Actions | Automated pipeline with SHA pinning |

### Security Stack

- **SonarCloud**: Static Application Security Testing (SAST) & Quality Gates
- **Trivy**: Container Image & Filesystem Vulnerability Scanning
- **GitHub Actions**: Job-level permissions and SHA/Semantic version pinning

---

## 📁 Project Structure

```
├── .github/
│   └── workflows/
│       └── devsecops-pipeline.yml    # Multi-stage CI/CD pipeline
├── terraform/
│   ├── provider.tf                   # AWS provider configuration
│   └── main.tf                       # ECR repository + lifecycle policy
├── index.js                         # Express API (hardened)
├── package.json                      # Dependencies with security overrides
├── Dockerfile                       # Multi-stage production build
├── docker-compose.yml               # Local development setup
├── sonar-project.properties         # SonarCloud configuration
└── README.md                        # This file
```

---

## 🛠️ Challenges Faced & Engineering Solutions

### Problem 1: AWS Access Denied
| Detail | Value |
|--------|-------|
| **Issue** | IAM user `ayu` lacked `ecr:CreateRepository` permissions |
| **Root Cause** | Missing identity-based policy on the IAM user |
| **Resolution** | Applied Principle of Least Privilege by attaching specific ECR policies via AWS Console |

### Problem 2: Pipeline "Resource Not Accessible"
| Detail | Value |
|--------|-------|
| **Issue** | GitHub Actions token was read-only for security events |
| **Root Cause** | Default token permissions are minimal |
| **Resolution** | Implemented **Job-Level Permissions** (`security-events: write`) for SARIF uploads |

### Problem 3: SonarCloud Quality Gate Failures
| Detail | Value |
|--------|-------|
| **Issue** | Unpinned GitHub Action tags flagged as supply-chain risk |
| **Root Cause** | Using `@v4` instead of full commit SHAs |
| **Resolution** | Hardened workflow with **verified full SHA pinning** for all third-party actions |

### Problem 4: Container CVEs (High/Medium)
| Detail | Value |
|--------|-------|
| **Issue** | Outdated base image + vulnerable sub-dependencies (tar, glob, minimatch) |
| **Root Cause** | Stale node:20-alpine digest and unpinned transitive deps |
| **Resolution** | **Security Patching Sprint**: Updated base image, ran `npm audit fix --force`, added npm overrides |

### Problem 5: Git LFS Large File Errors
| Detail | Value |
|--------|-------|
| **Issue** | Terraform provider binary (648MB) exceeded GitHub's 100MB limit |
| **Root Cause** | Committed `.terraform/` directory to git |
| **Resolution** | Added `.terraform/` to `.gitignore`, used `git filter-branch` for history cleanup |

---

## 🚦 How to Reproduce

### 1. Infrastructure Setup

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 2. Local Development

```bash
# Install dependencies
npm install

# Run locally
npm start

# Docker build
docker build -t express-api:latest .

# Docker Compose
docker compose up -d
```

### 3. CI/CD Activation

1. Navigate to **GitHub Secrets** → **Actions**
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID` - Your AWS access key
   - `AWS_SECRET_ACCESS_KEY` - Your AWS secret key
   - `SONAR_TOKEN` - Your SonarCloud authentication token

3. Push code to the `main` branch to trigger the pipeline:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

---

## 🔮 What's Next? (Phase 2 & 3)

| Phase | Goal | Technologies |
|-------|------|--------------|
| **Phase 2** | Kubernetes Deployment | Amazon EKS, Helm Charts |
| **Phase 3** | Monitoring & Observability | Prometheus, Grafana, AWS CloudWatch |
| **Phase 4** | Zero-Trust Authentication | OIDC (GitHub Actions → AWS) |

### Future Enhancements

- **OIDC Authentication**: Remove long-lived AWS keys in favor of GitHub OIDC for better security posture
- **Policy-as-Code**: IntegrateOPA/Gatekeeper for runtime policy enforcement
- **Multi-Environment**: Add staging/production promotion workflows

---

## 📊 Pipeline Overview

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Code Commit    │────▶│  security-scan    │────▶│ sonarcloud-scan │
│  (push to main) │     │  (Trivy FS Scan)  │     │  (Quality Gate) │
└─────────────────┘     └──────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   AWS ECR       │◀────│  build-and-push  │◀────│  Build Docker   │
│   (v1 tagged)   │     │  (Trivy Image)   │     │  Image          │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

### Pipeline Jobs

1. **security-scan** - Trivy filesystem vulnerability scan
2. **sonarcloud-scan** - SonarCloud SAST and quality gate
3. **build-and-push** - Docker build, image scan, ECR push

---

## 👤 About the Author

### Ayush Roy

**Multicloud CIS Engineer Trainee @ Cognizant**

I am a cloud enthusiast currently based in Bengaluru, specializing in AWS infrastructure and DevSecOps automation. With a background in managing IT service logistics and technical support for global clients (including Aberdeen PLC), I focus on bridging the gap between traditional IT operations and modern, security-first cloud engineering.

#### 🔐 Certifications
- AWS Certified Solutions Architect – Associate (SAA-C03)
- Oracle Cloud Infrastructure Architect

#### 🌐 Connect
- **GitHub**: [@AyushxOD](https://github.com/AyushxOD)
- **LinkedIn**: [Ayush Roy](https://www.linkedin.com/in/ayush-roy-a68079233/)
- **Portfolio**: [Ayush.Social](https://ayush.social/)
---

## 📜 License

MIT License - feel free to use, modify, and distribute.

---

*Built with ❤️ using GitHub Actions, AWS, Claude Code, Gemini, SonarCloud, and Trivy*
