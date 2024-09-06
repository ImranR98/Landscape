#!/bin/bash -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
helm repo update
helm upgrade cert-manager jetstack/cert-manager --values "$HERE"/values.yaml --set crds.enabled=true --namespace production
kubectl -n production rollout restart deployment cert-manager cert-manager-cainjector cert-manager-webhook
echo "NOTE: The Helm chart was updated, but there is no guarantee that the chart is in sync with the latest service release."