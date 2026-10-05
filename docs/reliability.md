# Reliability Targets

## Service

DevOps Lab API

## SLI

Availability is the proportion of HTTP requests that do not return a 5xx response.

Prometheus query:

    1 - (
      sum(rate(http_requests_total{job="devops-lab-api",status="5xx"}[5m]))
      /
      clamp_min(
        sum(rate(http_requests_total{job="devops-lab-api"}[5m])),
        0.000001
      )
    )

## SLO

Target availability: **99.5%**

No more than 0.5% of requests should fail with a 5xx response during the SLO period.

## Error Budget

Error budget: **0.5%**

For 10,000 requests:

- 9,950 must succeed
- up to 50 may fail

## Alerting

Current alerts:

- `DevOpsLabAPIDown` — API cannot be scraped for at least 1 minute
- `DevOpsLabAPIHigh5xxRate` — more than 5% of requests return 5xx for at least 2 minutes

Alerts are routed through Alertmanager to Slack.

## Incident Response

When `DevOpsLabAPIDown` fires:

1. Check Kubernetes pod state.
2. Check deployment rollout status.
3. Check application logs in Grafana/Loki.
4. Check the latest GitHub Actions deployment.
5. Restore or roll back the application if required.
6. Confirm Prometheus sees the API as healthy.
7. Confirm the Slack alert resolves.
