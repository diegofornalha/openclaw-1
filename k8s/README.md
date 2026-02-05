# OpenClaw Kubernetes Deployment

Deploy do OpenClaw Gateway no Kubernetes com WhatsApp + MiniMax.

## Arquivos

| Arquivo              | Descricao                                           |
| -------------------- | --------------------------------------------------- |
| `01-namespace.yaml`  | Namespace `openclaw`                                |
| `02-secrets.yaml`    | API keys (MiniMax, Gateway Token)                   |
| `03-configmap.yaml`  | Configuracao do OpenClaw                            |
| `04-pvc.yaml`        | Volumes persistentes (dados + credenciais WhatsApp) |
| `05-deployment.yaml` | Deployment do Gateway                               |
| `06-service.yaml`    | Services (ClusterIP + NodePort)                     |

## Deploy

```bash
cd /home/agents/openclaw/k8s
chmod +x deploy.sh
./deploy.sh
```

Ou manualmente:

```bash
kubectl apply -f 01-namespace.yaml
kubectl apply -f 02-secrets.yaml
kubectl apply -f 03-configmap.yaml
kubectl apply -f 04-pvc.yaml
kubectl apply -f 05-deployment.yaml
kubectl apply -f 06-service.yaml
```

## Conectar WhatsApp

Apos o deploy, conecte o WhatsApp:

```bash
# Entrar no pod
kubectl exec -it -n openclaw deployment/openclaw-gateway -- bash

# Gerar QR Code
cd /app/openclaw
pnpm openclaw channels login
```

Escaneie o QR code com o WhatsApp no celular.

## Verificar Status

```bash
# Ver pods
kubectl get pods -n openclaw

# Ver logs
kubectl logs -f -n openclaw -l app=openclaw

# Status do WhatsApp
kubectl exec -n openclaw deployment/openclaw-gateway -- pnpm openclaw channels status
```

## Acesso

- **Interno (ClusterIP)**: `openclaw-gateway.openclaw.svc.cluster.local:18789`
- **Externo (NodePort)**: `http://<NODE_IP>:30789`

## Seguranca

O agente `leads` tem as seguintes restricoes:

**Ferramentas BLOQUEADAS:**

- exec, process (sem execucao de comandos)
- gateway, cron (sem acesso a infra)
- sessions_spawn, sessions_send (sem criar/enviar sessoes)
- browser, canvas, nodes (sem acesso a UI/devices)
- message, agents_list (sem listar agentes)
- memory_search, memory_get (sem acesso a memoria global)
- elevated: disabled (sem modo elevado)

**Apenas permitido:**

- read, write, edit (arquivos no workspace do lead)
- web_search, web_fetch (pesquisa web)

## Backup de Credenciais WhatsApp

As credenciais do WhatsApp ficam em `/data/state/credentials`.
Para backup:

```bash
kubectl cp openclaw/$(kubectl get pod -n openclaw -l app=openclaw -o jsonpath='{.items[0].metadata.name}'):/data/state/credentials ./backup-creds
```

## Troubleshooting

### Pod nao inicia

```bash
kubectl describe pod -n openclaw -l app=openclaw
kubectl logs -n openclaw -l app=openclaw --previous
```

### WhatsApp desconectado

```bash
kubectl exec -n openclaw deployment/openclaw-gateway -- pnpm openclaw channels login
```

### Reiniciar deployment

```bash
kubectl rollout restart deployment/openclaw-gateway -n openclaw
```

### Deletar tudo

```bash
kubectl delete namespace openclaw
```
