#!/usr/bin/env bash
set -u
repo="$HOME/csce465-agentsec/465-HW3"
runtime="$HOME/csce465-agentsec/hw3"
out="$repo/evidence/task4"
mkdir -p "$out"
cd "$runtime" || exit 1
ulimit -c 0
sudo -v || exit 1
start="$(date '+%Y-%m-%d %H:%M:%S')"
{
  printf 'timestamp: %s\n' "$start"
  printf 'profile status:\n'
  sudo aa-status | grep -F "$runtime/legacy_log_parser" || true
  printf 'agentlab identity:\n'
  id agentlab
  printf 'decoy DAC mode:\n'
  stat -c '%n %a %U:%G' /opt/agentsec/decoy.txt
  printf 'marker before:\n'
  stat -c '%n %s bytes %y %U:%G' markers/ret2win.txt || true
  printf '\nagentlab confined payload run:\n'
  sudo -u agentlab "$runtime/legacy_log_parser" "$runtime/inbox/payload.bin" 2>&1
  printf 'agentlab parser exit: %d\n' "$?"
  printf 'marker after agentlab run:\n'
  stat -c '%n %s bytes %y %U:%G' markers/ret2win.txt || true
  cat markers/ret2win.txt || true
  printf '\nroot confined payload run (MAC cross-check):\n'
  sudo "$runtime/legacy_log_parser" "$runtime/inbox/payload.bin" 2>&1
  printf 'root parser exit: %d\n' "$?"
  printf 'marker after root run:\n'
  stat -c '%n %s bytes %y %U:%G' markers/ret2win.txt || true
  cat markers/ret2win.txt || true
} > "$out/confined-run.txt" 2>&1
sudo journalctl -k --since "$start" --no-pager -o short-iso > "$out/kernel-since-run.txt" 2>&1
grep -E 'apparmor=.*(DENIED|AUDIT)|audit:.*apparmor|legacy_log_parser|decoy.txt' "$out/kernel-since-run.txt" > "$out/denials.txt" || true
printf 'run output:\n'
cat "$out/confined-run.txt"
printf '\ndenial records:\n'
cat "$out/denials.txt"
printf '\ngit status:\n'
git -C "$repo" status --short
