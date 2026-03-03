# Reliability Manifests

Production-ready manifests for Kubernetes application reliability and high availability.

## Contents

### PodDisruptionBudgets (PDBs)

PDBs protect applications during voluntary disruptions (node drains, upgrades, scaling):

| File | Use Case |
|------|----------|
| `pdb-stateless-frontend.yaml` | Web frontends - keep 80% available |
| `pdb-stateful-quorum.yaml` | Quorum-based systems (etcd, ZooKeeper) - maxUnavailable: 1 |
| `pdb-critical-singleton.yaml` | Critical single-instance workloads - block eviction |

**Best Practices:**
- Every production Deployment/StatefulSet should have a PDB
- Use `maxUnavailable: 1` for stateful apps with quorum requirements
- Use percentage-based `minAvailable` for stateless services that scale
- Never set `maxUnavailable: 0` unless you have operational procedures for manual approval

### HorizontalPodAutoscalers (HPAs)

HPAs automatically scale pods based on metrics:

| File | Use Case |
|------|----------|
| `hpa-cpu-memory.yaml` | Multi-metric scaling (CPU + Memory) |
| `hpa-custom-metrics.yaml` | Custom application metrics (requests/sec) |
| `hpa-scale-to-zero.yaml` | KEDA-style scaling with minReplicas: 0 (K8s 1.27+) |

**Best Practices:**
- Always set both CPU and memory metrics to prevent one from masking the other
- Set `minReplicas` ≥ 2 for high availability
- Use `stabilizationWindowSeconds` to prevent flapping
- Coordinate with VPA: use VPA in "Off" or "Initial" mode alongside HPA

## Usage

```bash
# Apply a PDB for your app
kubectl apply -f pdb-stateless-frontend.yaml

# Apply HPA
kubectl apply -f hpa-cpu-memory.yaml

# Check PDB status
kubectl get pdb

# Check HPA status  
kubectl get hpa
```

## Integration with Other Manifests

Combine reliability manifests with:
- `../networkpolicies/` - Network isolation
- `../pod-security/` - Security contexts
- `../monitoring/` - Alerting on PDB violations

## References

- [Pod Disruption Budgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Multi-metric HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#autoscaling-on-multiple-metrics-and-custom-metrics)
