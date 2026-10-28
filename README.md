# CSCE 465 HW3

This checkout is `~/csce465-agentsec/465-HW3`. The assignment's runtime directory is a separate path, `~/csce465-agentsec/hw3`. Run the parser from that runtime directory so `win()` writes `hw3/markers/ret2win.txt`. The exploit input for the agent lives in `hw3/inbox/payload.bin`.

## Task 0: tools

```bash
sudo apt update
sudo apt install -y build-essential gdb binutils checksec apparmor-utils
```

## Task 1: vulnerable parser and direct run

From this checkout:

```bash
gcc -O0 -g -fno-stack-protector -no-pie -Wl,-z,noexecstack \
  -Wall -Wextra -o legacy_log_parser src/legacy_log_parser.c
checksec --file=./legacy_log_parser
python3 src/make_payload.py
mkdir -p ../hw3/inbox ../hw3/markers
cp payload.bin ../hw3/inbox/payload.bin
```

Run from the assignment's runtime directory:

```bash
cd ../hw3
../465-HW3/legacy_log_parser inbox/payload.bin
cat markers/ret2win.txt
```

The parser may exit with signal 11 after reaching `win()`. See `evidence/task1/direct-run-from-hw3.txt` for the saved direct run and marker at the required path. The stack overwrite offset is 152 bytes; the payload targets `win()` at `0x4012b6` for the recorded build. Recheck both values after recompiling.

## Task 2: OpenClaw skill and adversarial page

The submission page is `web/adversarial.html`. `task2/adversarial.html` is the original page used for the saved agent trace. The OpenClaw skill source is `skills/legacy-parser/SKILL.md` and its entry point is `skills/legacy-parser/run_parser.sh`. The Python wrapper checks that its only argument is an absolute path to a regular file directly inside `~/csce465-agentsec/hw3/inbox/`, rejects symlinks and outside paths, and runs the parser with `hw3` as its working directory.

Install or refresh the local skill:

```bash
mkdir -p ~/.openclaw/workspace/skills/legacy-parser
cp skills/legacy-parser/SKILL.md skills/legacy-parser/run_parser.sh \
  ~/.openclaw/workspace/skills/legacy-parser/
```

A direct wrapper check is recorded in `evidence/task2/wrapper-path-and-payload-tests.txt`. The saved OpenClaw agent trace is `evidence/task2/agent-session-local-file.jsonl`; its exact prompt is `evidence/task2/agent-request-local-file.txt`. That trace was captured before the working-directory correction and reads `task2/adversarial.html`. The current wrapper and required marker location are covered by the later direct-run evidence. See `evidence/task2/report.md` for the four-step explanation.

The course model key belongs in a terminal environment variable, never in this repository. `task2/start-course-model.sh` starts the local course model shim after the key is set.
