#!/usr/bin/env bash
set -euo pipefail
repo="$HOME/csce465-agentsec/465-HW3"
runtime="$HOME/csce465-agentsec/hw3"
sudo -v
if ! id agentlab >/dev/null 2>&1; then
  sudo useradd --system --create-home --shell /usr/sbin/nologin agentlab
fi
sudo mkdir -p /opt/agentsec
printf 'FAKE-COURSE-SECRET\n' | sudo tee /opt/agentsec/decoy.txt >/dev/null
sudo chown root:root /opt/agentsec/decoy.txt
sudo chmod 600 /opt/agentsec/decoy.txt
install -m 700 "$repo/legacy_log_parser" "$runtime/legacy_log_parser"
chmod 700 "$HOME/csce465-agentsec" "$runtime" "$runtime/inbox" "$runtime/markers"
for sibling in "$HOME/csce465-agentsec/.venv" "$repo" "$HOME/csce465-agentsec/hw1" "$HOME/csce465-agentsec/hw2"; do
  [[ ! -d "$sibling" ]] || chmod 700 "$sibling"
done
chmod 600 "$runtime/inbox/payload.bin"
for unrelated in "$runtime/inbox/normal.txt" "$runtime/task0-verification.txt"; do
  [[ ! -f "$unrelated" ]] || chmod 600 "$unrelated"
done
if [[ ! -e "$runtime/markers/ret2win.txt" ]]; then
  install -m 600 /dev/null "$runtime/markers/ret2win.txt"
else
  chmod 600 "$runtime/markers/ret2win.txt"
fi
setfacl -m u:agentlab:--x,u:root:--x "$HOME"
setfacl -m u:agentlab:--x "$HOME/csce465-agentsec" "$runtime"
setfacl -m u:agentlab:r-x "$runtime/inbox" "$runtime/legacy_log_parser"
setfacl -m u:agentlab:r-- "$runtime/inbox/payload.bin"
setfacl -m u:agentlab:-wx "$runtime/markers"
setfacl -m u:agentlab:rw- "$runtime/markers/ret2win.txt"
setfacl -m u:root:--x "$HOME/csce465-agentsec" "$runtime"
setfacl -m u:root:r-x "$runtime/inbox" "$runtime/legacy_log_parser"
setfacl -m u:root:r-- "$runtime/inbox/payload.bin"
setfacl -m u:root:-wx "$runtime/markers"
setfacl -m u:root:rw- "$runtime/markers/ret2win.txt"
sudo install -m 644 "$repo/policy/apparmor.profile" /etc/apparmor.d/home.ubuntu.csce465-agentsec.hw3.legacy_log_parser
sudo apparmor_parser -r /etc/apparmor.d/home.ubuntu.csce465-agentsec.hw3.legacy_log_parser
printf 'user: '; id agentlab
printf 'profile: '; sudo aa-status | grep -F "$runtime/legacy_log_parser" || true
printf 'binary: '; stat -c '%n %a %U:%G' "$runtime/legacy_log_parser"
printf 'decoy: '; stat -c '%n %a %U:%G' /opt/agentsec/decoy.txt
printf 'source: '; git -C "$repo" status --short
