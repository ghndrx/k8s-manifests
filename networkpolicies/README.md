# Kubernetes Network Policies

Zero-trust network security for Kubernetes workloads.

## Why Network Policies?

By default, Kubernetes allows all pod-to-pod communication. This violates the principle of least privilege and expands the blast radius of compromised workloads.

**Network Policies enforce:**
- East-west traffic segmentation
- Namespace isolation
- Egress control (prevent data exfiltration)
- Compliance requirements (PCI-DSS, SOC2, HIPAA)

## Quick Start

### 1. Apply Default Deny (per namespace)

```bash
kubectl apply -f default-deny-all.yaml -n <namespace>
```

### 2. Allow Essential Traffic

```bash
# DNS is required for almost everything
kubectl apply -f allow-dns-egress.yaml -n <namespace>

# If pods need to talk to each other
kubectl apply -f allow-same-namespace.yaml -n <namespace>
```

### 3. Add Application-Specific Policies

Label pods that should receive ingress traffic:
```yaml
metadata:
  labels:
    network.kubernetes.io/allow-ingress: "true"
```

Label pods exposing metrics:
```yaml
metadata:
  labels:
    prometheus.io/scrape: "true"
```

## Policy Files

| File | Purpose |
|------|---------|
| `default-deny-all.yaml` | Block all traffic (start here) |
| `allow-dns-egress.yaml` | Allow DNS resolution |
| `allow-same-namespace.yaml` | Allow intra-namespace traffic |
| `allow-ingress-from-ingress-controller.yaml` | Allow traffic from nginx-ingress |
| `allow-monitoring-scrape.yaml` | Allow Prometheus to scrape metrics |

## Best Practices

1. **Start with deny-all** - Apply `default-deny-all.yaml` first
2. **Allow DNS immediately** - Without DNS, nothing works
3. **Use specific selectors** - Avoid broad `podSelector: {}` in allow policies
4. **Label consistently** - Use standard labels for policy selection
5. **Test in non-prod first** - Network policies can break applications
6. **Monitor policy hits** - Use Cilium/Calico metrics for visibility

## CNI Requirements

Network Policies require a CNI that supports them:
- ✅ Cilium
- ✅ Calico
- ✅ Weave Net
- ✅ Antrea
- ❌ Flannel (no NetworkPolicy support without Calico)
- ❌ AWS VPC CNI (use Calico addon)

Verify your CNI supports NetworkPolicy before deploying.

## Debugging

```bash
# Check if policies are applied
kubectl get networkpolicies -n <namespace>

# Describe policy details
kubectl describe networkpolicy <name> -n <namespace>

# Test connectivity (from a debug pod)
kubectl run debug --rm -it --image=nicolaka/netshoot -- bash
# Then: curl, nc, dig to test connectivity
```

## References

- [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Network Policy Editor (visual)](https://editor.networkpolicy.io/)
- [Cilium Network Policy Guide](https://docs.cilium.io/en/stable/security/policy/)
