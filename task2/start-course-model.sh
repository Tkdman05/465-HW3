#!/usr/bin/env bash
set -euo pipefail
if [[ -z "${TAMU_API_KEY:-}" ]]; then
  echo 'Set TAMU_API_KEY in this terminal first. Do not save it in this repository.' >&2
  exit 2
fi
if curl -fsS --max-time 2 http://127.0.0.1:8899/openai/models >/dev/null 2>&1; then
  echo 'Course model shim is already listening on port 8899.'
  exit 0
fi
nohup node /home/ubuntu/csce465-agentsec/hw1/tamu-shim.mjs >/tmp/tamu-shim-task2.log 2>&1 </dev/null &
for _ in $(seq 1 20); do
  if ss -ltn | grep -q ':8899 '; then
    echo 'Course model shim started on port 8899.'
    exit 0
  fi
  sleep 0.25
done
echo 'Shim did not start; inspect /tmp/tamu-shim-task2.log.' >&2
exit 1
