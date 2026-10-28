#!/bin/bash

echo "=== Testing Fixed Parser ==="
echo ""

echo "[TEST 1] Valid short input:"
echo "test" > test_short.txt
./legacy_log_parser_fixed test_short.txt
echo ""

echo "[TEST 2] Exactly 128 bytes (maximum allowed):"
python3 -c "print('A' * 128, end='')" > test_max.txt
./legacy_log_parser_fixed test_max.txt
echo ""

echo "[TEST 3] One byte over limit (129 bytes):"
python3 -c "print('B' * 129, end='')" > test_over.txt
./legacy_log_parser_fixed test_over.txt
echo ""

echo "[TEST 4] Missing file:"
./legacy_log_parser_fixed missing.txt
echo ""

echo "[TEST 5] Original exploit payload (160 bytes):"
./legacy_log_parser_fixed ./payload.bin
echo ""

echo "=== All tests completed ==="