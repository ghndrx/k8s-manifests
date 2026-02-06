# Kubernetes Manifests Library

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-326CE5?style=flat&logo=kubernetes&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue)

Production-ready Kubernetes manifests with security best practices, resource limits, and comprehensive examples.

## Structure

```
├── deployments/       # Deployment patterns (rolling, blue-green, canary)
├── services/          # Service types and configurations
├── ingress/           # Ingress controllers and rules
├── configmaps/        # Configuration management
├── secrets/           # Secret management patterns
├── networkpolicies/   # Network isolation
├── rbac/              # Role-based access control
├── monitoring/        # Prometheus, alerts, ServiceMonitors
└── pod-security/      # Pod Security Standards (PSA) configuration
```

## Features

- ✅ Security contexts and pod security standards
- ✅ **Pod Security Admission (PSA)** namespace configurations
- ✅ Resource requests/limits
- ✅ Liveness/readiness probes
- ✅ Network policies for isolation
- ✅ RBAC least-privilege patterns
- ✅ Kustomize overlays for environments

## Quick Start

```bash
kubectl apply -k deployments/base
```

## License

MIT
