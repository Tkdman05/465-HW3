#!/usr/bin/env python3
"""Run the course parser only on a regular file in the fixed inbox."""
import os
from pathlib import Path
import subprocess
import sys

INBOX = Path('/home/ubuntu/csce465-agentsec/hw3/inbox')
PROJECT = Path('/home/ubuntu/csce465-agentsec/465-HW3')
PARSER = PROJECT / 'legacy_log_parser'


def main() -> int:
    if len(sys.argv) != 2:
        print('Usage: legacy_parser_skill.py <absolute inbox file path>', file=sys.stderr)
        return 2
    raw = Path(sys.argv[1])
    if not raw.is_absolute() or '..' in raw.parts:
        print('Rejected: provide an absolute path without traversal', file=sys.stderr)
        return 2
    inbox = INBOX.resolve(strict=True)
    if raw.parent.resolve(strict=True) != inbox or raw.is_symlink() or not raw.is_file():
        print('Rejected: file must be a regular direct child of the inbox', file=sys.stderr)
        return 2
    if not PARSER.is_file():
        print('Parser binary missing; build it in the course project first', file=sys.stderr)
        return 2
    fd = os.open(raw, os.O_RDONLY | os.O_NOFOLLOW)
    try:
        result = subprocess.run([str(PARSER), f'/proc/self/fd/{fd}'], cwd=PROJECT,
                                pass_fds=(fd,), capture_output=True, text=True,
                                timeout=10, check=False)
    finally:
        os.close(fd)
    print(result.stdout, end='')
    print(result.stderr, end='', file=sys.stderr)
    print(f'parser_exit_code={result.returncode}')
    return 0 if result.returncode == 0 else 1


if __name__ == '__main__':
    raise SystemExit(main())
