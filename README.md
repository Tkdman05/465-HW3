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

## Task 2: Fix and harden the program


## Task 3: Fix and Harden the Program

### Compile with Security Hardening
```bash
gcc -O2 -g -fstack-protector-strong -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 \
    -fPIE -pie -Wl,-z,relro,-z,now -Wl,-z,noexecstack \
    -Wall -Wextra -Werror \
    -o legacy_log_parser_fixed src/legacy_log_parser_fixed.c
```

### Compare Security Properties
```bash
checksec --file=./legacy_log_parser        # Vulnerable version
checksec --file=./legacy_log_parser_fixed  # Hardened version
```

### Test Cases
```bash
./evidence/task3/run_tests.sh

- [1] Valid short input (processes)
- [2] Exactly 128 bytes (processes)  
- [3] 129 bytes or more (rejected)
- [4] missing file (rejected)
- [5] Original payload.bin (rejected)