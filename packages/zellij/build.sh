#!/usr/bin/env bash
# Usage: build.sh <upstream-src-dir> <out-dir>; env: VERSION (deb version).
set -euo pipefail
src=$(realpath "$1"); out=$(realpath "$2")

sudo apt-get update
sudo apt-get install -y --no-install-recommends pkg-config libssl-dev
# Same protoc version as upstream's release workflow (distro one is too old).
case "$(uname -m)" in x86_64) pa=x86_64 ;; aarch64) pa=aarch_64 ;; esac
curl -sSfL -o "$RUNNER_TEMP/protoc.zip" "https://github.com/protocolbuffers/protobuf/releases/download/v23.4/protoc-23.4-linux-$pa.zip"
unzip -q -o "$RUNNER_TEMP/protoc.zip" -d "$RUNNER_TEMP/protoc"
export PATH="$RUNNER_TEMP/protoc/bin:$PATH"

cargo install cargo-deb --locked
cd "$src"
cargo xtask build --release   # builds wasm plugins, then target/release/zellij
cargo deb --no-build --deb-version "$VERSION" -o "$out/"
