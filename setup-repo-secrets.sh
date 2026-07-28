#!/usr/bin/env bash
#
# setup-repo-secrets.sh
#
# Pushes standard CI/CD secrets and variables into a new GitHub repo
# using the GitHub CLI (gh). Run this once per new repo, right after
# creating it, so your GitHub Actions workflows (dev/prod deploys,
# Claude Code action, etc.) have everything they need.
#
# Prerequisites:
#   - GitHub CLI installed and authenticated: gh auth login
#   - You have admin access to the target repo
#
# Usage:
#   ./setup-repo-secrets.sh <owner>/<repo>
#
# Example:
#   ./setup-repo-secrets.sh steve-dev/quelby-service

set -euo pipefail

REPO="${1:-}"

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <owner>/<repo>"
  exit 1
fi

echo "Setting up secrets and variables for $REPO ..."

# ---- Secrets (sensitive values, encrypted at rest) ----
# Edit these to pull from your local env, a password manager CLI,
# or prompt interactively. Shown here as env var references for safety.

gh secret set ANTHROPIC_API_KEY   --repo "$REPO" --body "$ANTHROPIC_API_KEY"
gh secret set AWS_ACCESS_KEY_ID   --repo "$REPO" --body "$AWS_ACCESS_KEY_ID"
gh secret set AWS_SECRET_ACCESS_KEY --repo "$REPO" --body "$AWS_SECRET_ACCESS_KEY"

# Add any additional per-project secrets here, e.g.:
# gh secret set DATABASE_URL --repo "$REPO" --body "$DATABASE_URL"

# ---- Variables (non-sensitive config, visible in the UI) ----

gh variable set AWS_REGION        --repo "$REPO" --body "us-east-1"
gh variable set DEV_ENVIRONMENT_NAME  --repo "$REPO" --body "dev"
gh variable set PROD_ENVIRONMENT_NAME --repo "$REPO" --body "production"

# Add any additional per-project variables here, e.g.:
# gh variable set STACK_NAME --repo "$REPO" --body "my-stack"

echo "Done. Secrets and variables configured for $REPO."
echo "Verify with: gh secret list --repo $REPO && gh variable list --repo $REPO"
