#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail

TOOL_NAME="serum"
BINARY_NAME="serum"

fail() { echo -e "\e[31mFail:\e[m $*" >&2; exit 1; }

list_all_versions() {
  mix hex.info serum 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V || echo "0.2.1"
}

download_release() {
  local version="$1" download_path="$2"
  mkdir -p "$download_path"
  echo "$version" > "$download_path/VERSION"
}

install_version() {
  local install_type="$1" version="$2" install_path="$3"

  mkdir -p "$install_path/bin"
  mix escript.install hex serum "$version" --force || fail "mix install failed"

  # Link escript to install path
  local escript_path="${HOME}/.mix/escripts/serum"
  if [[ -f "$escript_path" ]]; then
    cp "$escript_path" "$install_path/bin/serum"
    chmod +x "$install_path/bin/serum"
  fi
}
