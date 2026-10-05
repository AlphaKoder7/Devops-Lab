# Runbook: DevOpsLabAPIDown

## Alert

`DevOpsLabAPIDown`

Fires when Prometheus cannot scrape the DevOps Lab API for at least 1 minute.

## Impact

The API may be unavailable to users.

## Check Kubernetes

Run on the platform server:

    sudo k3s kubectl get pods -n default

    sudo k3s kubectl get deployment devops-lab-api

    sudo k3s kubectl rollout status deployment/devops-lab-api --timeout=120s

## Check Application Logs

Use Grafana Explore with the Loki datasource:

    {cluster="devops-lab", namespace="default", container="api"}

Or inspect directly:

    sudo k3s kubectl logs deployment/devops-lab-api --tail=100

## Check Recent Deployment

Review the latest GitHub Actions workflow run and confirm:

- tests passed
- image build succeeded
- deployment completed
- deployed image SHA matches the intended commit

## Recovery

If the deployment is scaled down:

    sudo k3s kubectl scale deployment devops-lab-api --replicas=1

If the pod is unhealthy:

    sudo k3s kubectl rollout restart deployment/devops-lab-api

Then verify:

    sudo k3s kubectl rollout status deployment/devops-lab-api --timeout=120s

## Validate Recovery

Check the service:

    curl http://localhost/health

Expected response:

    {"status":"healthy"}

Confirm:

- API pod is Running
- Prometheus is scraping the API
- `DevOpsLabAPIDown` clears
- Slack receives a RESOLVED notification

## Escalation

If the API still fails:

1. Check pod events.
2. Check container logs.
3. Check image/tag deployed by Helm.
4. Check Traefik and ingress.
5. Check node disk and memory.
6. Roll back the deployment if the latest release introduced the failure.
