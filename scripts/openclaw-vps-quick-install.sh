#!/usr/bin/env bash
set -euo pipefail

# OpenClaw VPS quick install (Ubuntu recommended)
# - Install basic deps (curl/git)
# - Check Node >= 22
# - Call official OpenClaw installer
# - Run onboarding with daemon
# - Run doctor/status/health (best-effort)

say() { printf "\n[%s] %s\n" "$(date +'%F %T')" "$*"; }

say "Preflight: OS"
uname -a || true

say "Install dependencies (curl, ca-certificates, git)"
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y curl ca-certificates git
else
  say "WARNING: apt-get not found. Please ensure curl/git are installed." >&2
fi

if ! command -v curl >/dev/null 2>&1; then
  say "ERROR: curl not found." >&2
  exit 1
fi

say "Check Node.js (must be >= 22)"
if ! command -v node >/dev/null 2>&1; then
  say "ERROR: Node not found. Install Node >= 22 first (fnm/nvm recommended)." >&2
  exit 2
fi

NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo 0)
if [[ "${NODE_MAJOR}" -lt 22 ]]; then
  say "ERROR: Node version must be >= 22. Current: $(node -v)" >&2
  exit 3
fi

say "Network check (best-effort): https://openclaw.ai"
if ! curl -fsSL --max-time 10 https://openclaw.ai >/dev/null; then
  say "WARNING: Cannot reach https://openclaw.ai (network/proxy/DNS)." >&2
  say "Fix network first if install fails: see docs/proxy.md" >&2
fi

say "Run official OpenClaw installer"
curl -fsSL https://openclaw.ai/install.sh | bash

say "Ensure openclaw on PATH"
if ! command -v openclaw >/dev/null 2>&1; then
  say "ERROR: openclaw not found on PATH." >&2
  say "Try: export PATH=\"$(npm prefix -g)/bin:$PATH\"" >&2
  exit 4
fi

say "Run onboarding (install daemon)"
openclaw onboard --install-daemon

say "Health checks (best-effort)"
openclaw doctor || true
openclaw status || true
openclaw health || true

say "Done. Next: connect from your laptop via SSH tunnel (docs/ssh-tunnel.md)"
