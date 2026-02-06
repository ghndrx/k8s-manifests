#!/bin/bash
# audit-namespaces.sh - Check PSA compliance across all namespaces
# Usage: ./audit-namespaces.sh [restricted|baseline]

set -euo pipefail

LEVEL="${1:-restricted}"

echo "=== Pod Security Standards Compliance Audit ==="
echo "Target level: $LEVEL"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# Get all namespaces
NAMESPACES=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

for NS in $NAMESPACES; do
  # Skip system namespaces
  if [[ "$NS" == "kube-system" || "$NS" == "kube-public" || "$NS" == "kube-node-lease" ]]; then
    echo "[$NS] SKIPPED (system namespace)"
    continue
  fi

  # Check current PSA labels
  CURRENT_LEVEL=$(kubectl get namespace "$NS" -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null || echo "none")

  # Dry-run label to check violations
  echo ""
  echo "=== Namespace: $NS (current: $CURRENT_LEVEL) ==="

  # Use --dry-run to preview what would be blocked
  kubectl label namespace "$NS" \
    "pod-security.kubernetes.io/enforce=$LEVEL" \
    "pod-security.kubernetes.io/warn=$LEVEL" \
    --dry-run=server \
    --overwrite 2>&1 | grep -E "(Warning|Error)" || echo "✓ No violations detected"

  # List pods that might violate
  echo ""
  echo "Pods in namespace:"
  kubectl get pods -n "$NS" -o wide --no-headers 2>/dev/null | head -5 || echo "  (no pods)"
done

echo ""
echo "=== Audit Complete ==="
echo ""
echo "To apply restricted level to a namespace:"
echo "  kubectl label namespace <name> \\"
echo "    pod-security.kubernetes.io/enforce=restricted \\"
echo "    pod-security.kubernetes.io/audit=restricted \\"
echo "    pod-security.kubernetes.io/warn=restricted \\"
echo "    --overwrite"
