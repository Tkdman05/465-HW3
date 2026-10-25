# 465 HW3

## Task 0: Lab Preparation
Install required tools for the assignment:
```bash
sudo apt update
sudo apt install -y build-essential gdb binutils checksec apparmor-utils
```

## Task 1: Write and analyze the vulnerable parser

### Setup
1. Create fake protected file:
```bash
sudo mkdir -p /opt/agentsec
printf 'FAKE-COURSE-SECRET\n' | sudo tee /opt/agentsec/decoy.txt
sudo chmod 600 /opt/agentsec/decoy.txt
```

2. Create directories:
```bash
mkdir -p markers src
```

### Compile Vulnerable Parser
```bash
gcc -O0 -g -fno-stack-protector -no-pie -Wl,-z,noexecstack \
    -Wall -Wextra -o legacy_log_parser src/legacy_log_parser.c
```

### Exploit Steps
1. Find win() address: `nm ./legacy_log_parser | grep win`
2. Use GDB to determine buffer-to-return-address offset (For me: 152 bytes found)
3. Create payload with Python script to overwrite return address
4. Execute: `./legacy_log_parser payload.bin`
5. Verify marker created: `ls markers/ret2win.txt`

## Task 2: Trace an agent-mediated invocation