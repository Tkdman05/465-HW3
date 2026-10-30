# AI Usage Disclosure — Wyatt Soper

### Tool/model and date: 
Claude Opus 4.1 on 10/24.

### Purpose:
Assist with finding the offset and address of win() for exploitation of vulnerable parser.

### AI Conversation Log files:
See evidence/tast1k/AT_log.md.

### What I used:
I used the response to better understand how GDB would be used to derive the overflow offset, specifically through file and memory manipulation.

### What I changed:
I used the information of address and offset to complete task 1 with the required information in src/make_payload.py.

### How I tested it:
I tested it by confirming that the methods described worked and gave accurate results of the required information, as shown by task 1 evidence that win() was able to be reached.

### One error, limitation, or rejected suggestion:
The model cannot help with finding the address and offset directly, only give methods and ideas on how to accomplish this goal.