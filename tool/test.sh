#!/usr/bin/env bash

set -euo pipefail

echo "\n=== Running tests with expanded reporter ==="
echo "Start: $(date)"

# Prefer expanded reporter for better visibility and no concurrency issues with verbose prints
flutter test -r expanded --concurrency=1 "$@"

status=$?
echo "\nEnd: $(date)"
exit $status


