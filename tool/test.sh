#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "\nSigma Notes - Tests"

# Detect flutter command (prefer fvm if available)
if command -v fvm >/dev/null 2>&1; then
  FLUTTER_CMD="fvm flutter"
else
  if command -v flutter >/dev/null 2>&1; then
    FLUTTER_CMD="flutter"
  else
    echo "❌ Neither 'fvm' nor 'flutter' found in PATH. Install Flutter or FVM and try again."
    exit 127
  fi
fi

QUIET="1"
EXPANDED="0"
if [[ ${1:-} == "--expanded" ]]; then
  EXPANDED="1"
  shift
fi

if [[ -z ${NO_PUBGET:-} ]]; then
  $FLUTTER_CMD pub get >/dev/null
fi

# Reporter and options
if [[ "$EXPANDED" == "1" ]]; then
  REPORTER="expanded"
  CONCURRENCY="1"
else
  REPORTER="compact"
  CONCURRENCY="8"
fi

# Optional filters:
#  - file paths: ./tool/test.sh test/services/device_info_service_test.dart
#  - -n "test name substring": ./tool/test.sh -n "Login with valid credentials"
ARGS=("-r" "$REPORTER" "--concurrency=$CONCURRENCY")

# Forward all user args (allows -n/--name, paths, etc.)
if [[ $# -gt 0 ]]; then
  $FLUTTER_CMD test "${ARGS[@]}" "$@"
else
  $FLUTTER_CMD test "${ARGS[@]}"
fi

STATUS=$?
exit $STATUS



