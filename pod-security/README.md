# Pod Security Standards (PSS) Configuration

Kubernetes Pod Security Admission (PSA) enforces the [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) at the namespace level.

## Security Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| **Privileged** | Unrestricted, allows all capabilities | System workloads, CNI, monitoring agents |
| **Baseline** | Prevents known privilege escalations | Most application workloads |
| **Restricted** | Hardened, follows best practices | Sensitive/untrusted workloads |

## Enforcement Modes

- `enforce` - Rejects pods that violate the policy
- `audit` - Logs violations but allows pods
- `warn` - Sends warnings to users but allows pods

## Quick Start

```bash
# Apply all namespace configurations
kubectl apply -f namespaces/

# Test a deployment against restricted namespace
kubectl apply -f examples/restricted-deployment.yaml -n restricted-apps
```

## Namespace Configuration

Each namespace is configured with PSA labels:

```yaml
labels:
  pod-security.kubernetes.io/enforce: restricted
  pod-security.kubernetes.io/enforce-version: latest
  pod-security.kubernetes.io/audit: restricted
  pod-security.kubernetes.io/warn: restricted
```

## Migration Strategy

1. Start with `audit` and `warn` modes to identify violations
2. Fix non-compliant workloads
3. Enable `enforce` mode

## Files

- `namespaces/` - Pre-configured namespaces for each security level
- `examples/` - Compliant deployment examples for each level
- `migration/` - Tools for auditing existing namespaces

## References

- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)
- [Migrate from PSP](https://kubernetes.io/docs/tasks/configure-pod-container/migrate-from-psp/)
