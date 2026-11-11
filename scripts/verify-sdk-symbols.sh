#!/usr/bin/env bash
# Checks that API names exist in the installed iOS SDK, so nothing in DuoLab
# (code, notes, docs, AI answers) depends on an API that was misremembered.
#
# Usage:
#   scripts/verify-sdk-symbols.sh                 # check every name in scripts/sdk-symbols.txt
#   scripts/verify-sdk-symbols.sh onHingeChange   # check specific names
#
# Exit code is 1 if any name is missing.

set -euo pipefail

SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
SDK_VERSION="$(xcrun --sdk iphoneos --show-sdk-version)"
FW="$SDK/System/Library/Frameworks"

SEARCH_PATHS=(
  "$FW/SwiftUI.framework"
  "$FW/SwiftUICore.framework"
  "$FW/UIKit.framework/Headers"
  "$FW/AVFoundation.framework/Headers"
  "$FW/AVKit.framework/Headers"
  "$FW/FoundationModels.framework"
  "$FW/_CoreSpotlight_FoundationModels.framework"
  "$FW/CoreSpotlight.framework"
)

if [[ $# -gt 0 ]]; then
  symbols=("$@")
else
  list="$(dirname "$0")/sdk-symbols.txt"
  symbols=()
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    symbols+=("$line")
  done < "$list"
fi

echo "iOS SDK $SDK_VERSION"
missing=0
for symbol in "${symbols[@]}"; do
  if grep -rqF --include='*.swiftinterface' --include='*.h' -- "$symbol" "${SEARCH_PATHS[@]}" 2>/dev/null; then
    echo "  ok       $symbol"
  else
    echo "  MISSING  $symbol"
    missing=$((missing + 1))
  fi
done

if [[ $missing -gt 0 ]]; then
  echo "$missing name(s) not found in the SDK."
  exit 1
fi
echo "All ${#symbols[@]} names found."
