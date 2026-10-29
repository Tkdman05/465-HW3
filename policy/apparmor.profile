#include <tunables/global>

# Confines the intentionally vulnerable Task 1 parser in the course VM.
profile /home/ubuntu/csce465-agentsec/hw3/legacy_log_parser {
  /home/ubuntu/csce465-agentsec/hw3/legacy_log_parser mr,
  /home/ubuntu/csce465-agentsec/hw3/inbox/payload.bin r,
  /home/ubuntu/csce465-agentsec/hw3/markers/ w,
  /home/ubuntu/csce465-agentsec/hw3/markers/ret2win.txt rw,

  /etc/ld.so.cache r,
  /lib/x86_64-linux-gnu/libc.so.6 mr,
  /usr/lib/x86_64-linux-gnu/libc.so.6 mr,
  /lib64/ld-linux-x86-64.so.2 mr,
  /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 mr,

  audit deny /opt/agentsec/decoy.txt rwklx,
  audit deny /bin/sh x,
  audit deny /bin/bash x,
  audit deny /bin/dash x,
  audit deny /usr/bin/sh x,
  audit deny /usr/bin/bash x,
  audit deny /usr/bin/dash x,
}
