#!/bin/bash
# Deploy OpenClaw no Kubernetes

set -e

echo "=== Deploying OpenClaw to Kubernetes ==="

# Criar namespace
echo "[1/6] Criando namespace..."
kubectl apply -f 01-namespace.yaml

# Criar secrets
echo "[2/6] Criando secrets..."
kubectl apply -f 02-secrets.yaml

# Criar configmap
echo "[3/6] Criando configmap..."
kubectl apply -f 03-configmap.yaml

# Criar PVCs
echo "[4/6] Criando persistent volumes..."
kubectl apply -f 04-pvc.yaml

# Criar deployment
echo "[5/6] Criando deployment..."
kubectl apply -f 05-deployment.yaml

# Criar services
echo "[6/6] Criando services..."
kubectl apply -f 06-service.yaml

echo ""
echo "=== Deploy completo! ==="
echo ""
echo "Comandos uteis:"
echo "  kubectl get pods -n openclaw"
echo "  kubectl logs -f -n openclaw -l app=openclaw"
echo "  kubectl exec -it -n openclaw deployment/openclaw-gateway -- bash"
echo ""
echo "Para conectar WhatsApp (QR Code):"
echo "  kubectl exec -it -n openclaw deployment/openclaw-gateway -- pnpm openclaw channels login"
echo ""
echo "Acesso externo: http://<NODE_IP>:30789"
