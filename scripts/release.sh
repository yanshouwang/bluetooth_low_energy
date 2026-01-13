#!/bin/bash

set -e

targets=(
  "bluetooth_low_energy_platform_interface"
  "bluetooth_low_energy_android"
  "bluetooth_low_energy_darwin"
  "bluetooth_low_energy_windows"
  "bluetooth_low_energy_linux"
  "bluetooth_low_energy"
)

publish() {
  local target=$1
  local version=$(sed -n 's/^version:[[:space:]]*["'\'']*\([^[:space:]''"''\'']*\).*/\1/p' "$target/pubspec.yaml")
  local tag="$target-$version"

  echo "Publishing $target version $version..."
  git tag "$tag"
  git push origin "$tag"
}

if [ -n "$1" ]; then
  publish "$1"
else
  for target in "${targets[@]}"; do
    publish "$target"
  done
fi