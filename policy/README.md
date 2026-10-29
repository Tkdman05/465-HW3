# Task 4 confinement (Linux 3)

The profile attaches to `/home/ubuntu/csce465-agentsec/hw3/legacy_log_parser`, a runtime copy of the Task 1 vulnerable binary. The repository checkout is `/home/ubuntu/csce465-agentsec/465-HW3`. These paths are intentionally separate. The profile permits one selected payload, marker output, and the startup loader files. All unlisted access is denied; the decoy and shell paths also have explicit audited denials.

From the repository checkout in Linux 3, first build the vulnerable parser using the Task 1 flags and generate `../hw3/inbox/payload.bin`. Then run:

```bash
bash tests/setup_task4.sh
bash tests/run_task4.sh
```

The setup script creates the `agentlab` system account if needed, creates a fake root-owned decoy, sets narrow DAC permissions and ACLs, installs the runtime binary, and loads the profile in enforce mode. The run script executes the original payload as `agentlab`, then as root through the same confined binary. The root run is a MAC cross-check: root can ordinarily read its own decoy, but the AppArmor profile blocks it. The `agentlab` run shows marker creation; its decoy access is already blocked by DAC, so the logged AppArmor decoy denial is attributed to the root run.

Evidence is saved under `evidence/task4/`: `confined-run.txt`, `denials.txt`, `apparmor-status.txt`, `dac-acl.txt`, and `kernel-since-run.txt`. A post-`win()` segmentation fault is expected for this original ret2win payload and does not negate the marker or denial evidence.
