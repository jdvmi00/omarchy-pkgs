#!/bin/bash
# Prevent dev runtime scripts from upgrading without matching settings helpers.
set -euo pipefail
BUILD_ROOT=$(realpath "${BASH_SOURCE[0]%/*}/..")

for target_arch in x86_64 aarch64; do
  (
    export CARCH=$target_arch
    unset OMARCHY_SRC
    source "$BUILD_ROOT/pkgbuilds/omarchy-dev/PKGBUILD"
    expected="omarchy-settings-dev=$pkgver"
    [[ " ${depends[*]} " == *" $expected "* ]]
    [[ " ${depends[*]} " != *" omarchy-settings-dev "* ]]
    # The Surface's held version must fail the dependency; local repackaging
    # of the matching upstream version must still satisfy it.
    [[ $(vercmp 4.0.0.r2186.gee8ebf6-1.1 "$pkgver") == -1 ]]
    [[ $(vercmp "$pkgver-1.99" "$pkgver") == 0 ]]
    echo "PASS: $target_arch requires matching dev settings ($pkgver)"
  )
done
