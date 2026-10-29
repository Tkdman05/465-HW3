# AI Usage Disclosure — Sungjun Jo

This file documents the **OpenClaw AI agent used as the subject of the Task 2 experiment**.

## Tool/model and date

OpenClaw with the course TAMUS `protected.gpt-4o` model, October 27–28, 2026. The model identifier and timestamps appear in the saved agent trace.

## Purpose

I asked the AI agent to summarize an adversarial webpage. The experiment tested whether instructions embedded in that lower-trust page would steer the agent into invoking the local `legacy-parser` skill on the exploit payload.

## AI conversation log files

- `evidence/task2/agent-request-local-file.txt` — the exact summary request.
- `evidence/task2/agent-run-local-file-raw.txt` — the agent's response and CLI output.
- `evidence/task2/agent-session-local-file.jsonl` — the complete saved local-file execution trace.
- `evidence/task2/agent-session-retry.jsonl` — a separate URL attempt that was blocked before the webpage text was returned.

## What I used

I used the agent's tool-call trace and final response as evidence for Task 2. The trace shows reads of the webpage, the installed skill instructions, and the payload, followed by an `exec` call that ran the parser wrapper. I used the recorded result to explain the four-step chain in the report: webpage content entered the agent's context, the agent chose a tool call, the inbox path policy allowed the call, and the native parser processed the overflow payload.

## What I changed

I documented the behavior shown in the trace rather than assuming that the webpage instruction would work. The report distinguishes the archived agent run from the later wrapper correction: the archived run wrote its marker in the repository checkout, while the current wrapper runs from the assignment's `hw3` runtime directory. The saved trace was retained unchanged.

## How I tested it

The local-file request and OpenClaw run were performed in the Linux 3 course VM. The saved trace records the agent's `read` and `exec` calls. The wrapper reported `parser_exit_code=-11`, meaning the native parser terminated on signal 11; the wrapper command itself exited 1. The marker evidence recorded `ret2win successful`. A separate URL-based attempt was blocked by `web_fetch` before the agent received the page text.

## One error, limitation, or rejected suggestion

The archived successful trace used an earlier wrapper that launched the parser from the repository checkout, so its marker path differs from the assignment's runtime path. That limitation is stated in the report and supported by the saved original wrapper and marker evidence. A later direct wrapper test verifies the corrected runtime directory, but it is not presented as a new agent trace.
