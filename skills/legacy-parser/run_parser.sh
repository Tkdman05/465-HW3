#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo 'Usage: run_parser.sh <absolute inbox file path>' >&2
  exit 2
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER="$SCRIPT_DIR/../../src/legacy_parser_skill.py"
if [[ ! -f "$WRAPPER" ]]; then
  WRAPPER="$HOME/csce465-agentsec/465-HW3/src/legacy_parser_skill.py"
fi
exec python3 "$WRAPPER" "$1"
