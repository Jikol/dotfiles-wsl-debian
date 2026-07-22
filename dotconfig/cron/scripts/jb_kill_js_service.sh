#!/usr/bin/env bash
# Kill lingering WebStorm js-language-service.js processes.
# Standalone (no fish dependency) so cron can call it directly.
set -euo pipefail

procs=$(pgrep -f js-language-service.js || true)

if [[ -z "$procs" ]]; then
  echo "No WebStorm js-language-service process running."
  exit 0
fi

count=$(wc -l <<<"$procs")
echo "Killing ${count} WebStorm js-language-service process(es)..."
pkill -9 -f js-language-service.js
