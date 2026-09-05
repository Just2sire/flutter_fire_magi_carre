#!/usr/bin/env bash
# Build MagiCarré for a given environment.
#
# Usage:
#   ./scripts/build.sh dev            # debug APK, config/dev.json, no obfuscation
#   ./scripts/build.sh prod           # release APK, config/prod.json, obfuscated, split per ABI
#   ./scripts/build.sh prod --bundle  # release AAB (Play Store) instead of split APKs
#
# Obfuscation maps symbols to build/app/outputs/symbols/ — keep that folder
# for every release you ship, it's required to de-obfuscate crash reports
# (flutter symbolize).

set -euo pipefail

env="${1:-}"
bundle="${2:-}"

if [[ "$env" != "dev" && "$env" != "prod" ]]; then
  echo "Usage: $0 <dev|prod> [--bundle]" >&2
  exit 1
fi

config_file="config/${env}.json"
if [[ ! -f "$config_file" ]]; then
  echo "Missing $config_file. Copy config/${env}.json.example and fill in your values." >&2
  exit 1
fi

if [[ "$env" == "dev" ]]; then
  echo "Building debug APK (config/dev.json)..."
  flutter build apk --debug --dart-define-from-file="$config_file"
  exit 0
fi

symbols_dir="build/app/outputs/symbols"
mkdir -p "$symbols_dir"

if [[ "$bundle" == "--bundle" ]]; then
  echo "Building release App Bundle (obfuscated, config/prod.json)..."
  flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info="$symbols_dir" \
    --dart-define-from-file="$config_file"
else
  echo "Building release APKs, split per ABI (obfuscated, config/prod.json)..."
  flutter build apk \
    --release \
    --obfuscate \
    --split-debug-info="$symbols_dir" \
    --split-per-abi \
    --dart-define-from-file="$config_file"
fi
