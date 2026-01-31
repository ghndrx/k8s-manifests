# Deployment Base Template

Production-ready Kubernetes deployment with **Pod Security Standards (PSS) restricted** compliance.

## Security Features

This template enforces the most restrictive Pod Security Standard:

- ✅ **Non-root execution** - Pods run as UID 1000
- ✅ **Read-only root filesystem** - Prevents runtime modifications
- ✅ **No privilege escalation** - `allowPrivilegeEscalation: false`
- ✅ **All capabilities dropped** - Minimal Linux capabilities
- ✅ **Seccomp profile** - RuntimeDefault seccomp filtering
- ✅ **Resource limits** - CPU and memory constraints

## Usage

### Deploy directly
```bash
kubectl apply -k .
```

### Use as a base with overlays
```yaml
# overlays/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
patches:
  - path: replicas-patch.yaml
```

## Customization Points

| Field | Default | Description |
|-------|---------|-------------|
| `replicas` | 2 | Number of pod replicas |
| `image` | nginx:1.27-alpine | Container image |
| `resources.requests.cpu` | 100m | CPU request |
| `resources.requests.memory` | 128Mi | Memory request |
| `resources.limits.cpu` | 500m | CPU limit |
| `resources.limits.memory` | 256Mi | Memory limit |

## Pod Security Standards Reference

The namespace is configured with PSS labels:

```yaml
pod-security.kubernetes.io/enforce: restricted
pod-security.kubernetes.io/audit: restricted  
pod-security.kubernetes.io/warn: restricted
```

See: https://kubernetes.io/docs/concepts/security/pod-security-standards/

## Health Probes

- **Liveness**: `/healthz` - Restart if unhealthy
- **Readiness**: `/ready` - Remove from service if not ready
- **Startup**: `/healthz` - Allow up to 150s for startup
