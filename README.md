# Various Static Sites

## Personal-Site
This will host my personal website, including CV.

## Wedding-Site
This will host our wedding website

## Deploy Workflows
Both site deploy workflows support manual runs from the GitHub Actions UI via `workflow_dispatch`:
1. `deploy-personal-site.yaml`
2. `deploy-wedding-site.yaml`

## Local Testing
From the repo root, use the Makefile targets below:

```bash
make local-personal
make local-wedding
```

`local-personal` serves on `http://localhost:8080/` and `local-wedding` serves on `http://localhost:8081/`.
