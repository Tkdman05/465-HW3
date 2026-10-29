.nr PS 11
.nr VS 14
.nr LL 6.8i
.nr LT 6.8i
.nr PO 0.85i
.ds CH
.TL
Task 4: Apply Access Control and AppArmor
.AU
Wyatt Soper and Sungjun Jo
.PP
Contribution statement: Wyatt Soper 50%; Sungjun Jo 50% (agreed team split).
.NH 1
Confinement design
.PP
We created the system account agentlab with /usr/sbin/nologin and installed the original Task 1 parser at /home/ubuntu/csce465-agentsec/hw3/legacy_log_parser. Unix permissions and ACLs give agentlab traversal to that binary, read access to the selected 160-byte inbox/payload.bin, and write access to the marker. Other course files and the root-owned decoy are inaccessible to agentlab. The AppArmor profile is loaded in enforce mode for the runtime binary.
.IP "1." 0.3i
Selected input: an exact-path r rule permits only hw3/inbox/payload.bin.
.IP "2." 0.3i
Output: w on the markers directory and rw on markers/ret2win.txt permit the marker write. No other application output path is allowed.
.IP "3." 0.3i
Protected file: audit deny /opt/agentsec/decoy.txt rwklx blocks and logs attempted decoy access.
.IP "4." 0.3i
Execution: shell paths have explicit audited execute denials. Every other unlisted executable is denied by the profile's default-deny rule.
.IP "5." 0.3i
Startup: the profile permits the parser, ld.so.cache, the dynamic linker, and libc. It grants no capabilities.
.NH 1
Observed run and denial
.PP
The saved tests/setup_task4.sh and tests/run_task4.sh reproduced the experiment in Linux 3. The agentlab payload run reached win(): markers/ret2win.txt changed and contained "ret2win successful". The original vulnerable parser then exited 139 (segmentation fault). The agentlab decoy access was already prevented by Unix DAC. A separate run of the same profiled binary as root isolated AppArmor's MAC decision: root could ordinarily read its own mode-600 decoy, but AppArmor denied the read. The root run also updated the marker and exited 139.
.PP
Kernel denial excerpt (wrapped for page width):
.DS L
.ps 9
.vs 11p
.nf
apparmor="DENIED" operation="open" class="file"
profile="/home/ubuntu/csce465-agentsec/hw3/legacy_log_parser"
name="/opt/agentsec/decoy.txt" requested_mask="r"
denied_mask="r" fsuid=0 ouid=0
.fi
.ps 11
.vs 14p
.DE
.PP
Full output is preserved in evidence/task4/confined-run.txt, denials.txt, apparmor-status.txt, and dac-acl.txt.
.bp
.sp 0.9i
.NH 1
Access control concepts (484 words)
.PP
The vulnerable parser still contains the unchecked copy demonstrated in Task 1. Task 4 tests a different boundary: whether the process can access resources beyond those needed to parse one chosen file and write its harmless marker. The exploit was run as a dedicated system user, agentlab, with no login shell. Unix directory permissions and ACLs let this user traverse the course runtime path, execute the parser, read the selected 160-byte payload, and write the marker. Other course files were made inaccessible to that account. The decoy file is owned by root with mode 600, so this low-privilege user cannot read it under ordinary Unix permissions.
.PP
An access matrix describes which subjects may perform which operations on which objects. Here, one row for agentlab would grant execute on the parser, read on the selected payload, and write on the marker. It would not grant read on the decoy. Unix ownership, mode bits, and ACLs implement this discretionary access control, or DAC: the owner or an administrator can change those grants. The ACLs are important because directory traversal permission is required even when a file itself is readable. We discovered a missing traverse permission on /home/ubuntu in the first run; after adding it, the program could execute as agentlab.
.PP
AppArmor adds mandatory access control, or MAC, tied to the parser executable. Its enforced profile lists allowed reads and writes and explicitly audits denial of the decoy. It also denies shells and all other unlisted execution paths. These rules apply independently of the account that starts the parser. To distinguish MAC from the decoy's DAC restriction, we repeated the profiled payload run as root. Root normally owns and can read the decoy, but the kernel logged an AppArmor denial for its attempted read. The saved record names the profile, decoy path, requested read operation, and root file-system UID. The agentlab run itself showed marker creation and a subsequent segmentation fault; it did not produce the decoy AppArmor denial used for the MAC cross-check.
.PP
A reference monitor is the mechanism that decides whether a subject may access an object. The kernel's DAC checks and AppArmor enforcement serve that role here. Complete mediation means each file open and attempted execution is checked at the time of access, not just when the program starts. This matters after the overflow redirects control to win(): the redirected code is still inside the confined process, so its attempt to open the decoy goes through the same checks. Least privilege means granting only the operations needed for the assigned job: one payload read, one marker write, the loader files required to start, and no shell or extra capabilities. The marker proves the overflow reached win() despite confinement. The denial proves that this code path could not read the fake secret during the privileged cross-check. Confinement limits the consequences of control-flow hijacking; the bounds check in Task 3 is what removes the memory-safety bug.
