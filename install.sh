#!/bin/sh
# Installs the dynctl CLI for macOS/Linux.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/qlik-download/CTL-Dynamic-Engine/main/install.sh | sh
#
#   # to pin a release, fetch the installer from that same tag:
#   curl -fsSL https://raw.githubusercontent.com/qlik-download/CTL-Dynamic-Engine/v1.2.3/install.sh | DYNCTL_VERSION=v1.2.3 sh
#
# Env vars:
#   DYNCTL_VERSION  release tag to install, e.g. v1.2.3 (default: latest)
#   INSTALL_DIR     directory to install into (default: /usr/local/bin)
set -eu

REPO="qlik-download/CTL-Dynamic-Engine"
RELEASES_URL="https://github.com/${REPO}/releases"

die() {
  echo "Error: $*" >&2
  exit 1
}

fetch() {
  url="$1"
  out="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$out" "$url" || die "download failed: $url"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$out" "$url" || die "download failed: $url"
  else
    die "curl or wget is required"
  fi
}

case "$(uname -s)" in
  Darwin) os=darwin ;;
  Linux) os=linux ;;
  *) die "Unsupported OS: $(uname -s). dynctl supports macOS and Linux only; see the README for Windows instructions." ;;
esac

case "$(uname -m)" in
  x86_64 | amd64) arch=amd64 ;;
  arm64 | aarch64) arch=arm64 ;;
  *) die "Unsupported architecture: $(uname -m)." ;;
esac

asset="dynctl-${os}-${arch}"

: "${DYNCTL_VERSION:=latest}"
if [ "$DYNCTL_VERSION" = "latest" ]; then
  download_base="${RELEASES_URL}/latest/download"
else
  download_base="${RELEASES_URL}/download/${DYNCTL_VERSION}"
fi
binary_url="${download_base}/${asset}"
checksums_url="${download_base}/SHA256SUMS"

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dynctl-install.XXXXXXXX") || die "mktemp failed"
trap 'rm -rf "$tmpdir"' EXIT INT TERM

fetch "$binary_url" "$tmpdir/$asset"
fetch "$checksums_url" "$tmpdir/SHA256SUMS"

grep -E "[[:space:]]${asset}\$" "$tmpdir/SHA256SUMS" > "$tmpdir/SHA256SUMS.filtered" \
  || die "checksum entry for $asset not found in SHA256SUMS"

(
  cd "$tmpdir"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum -c SHA256SUMS.filtered
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 -c SHA256SUMS.filtered
  else
    die "neither sha256sum nor shasum is available to verify the download"
  fi
) >/dev/null || die "checksum verification FAILED for $asset. Downloaded file does not match SHA256SUMS. Aborting -- nothing was installed."

chmod +x "$tmpdir/$asset"

install_dir="${INSTALL_DIR:-/usr/local/bin}"
target="$install_dir/dynctl"

if [ ! -d "$install_dir" ]; then
  parent=$(dirname "$install_dir")
  if [ -w "$parent" ] || [ "$(id -u)" = "0" ]; then
    mkdir -p "$install_dir" || die "failed to create $install_dir"
  elif command -v sudo >/dev/null 2>&1; then
    sudo mkdir -p "$install_dir" || die "failed to create $install_dir (sudo)"
  else
    die "$install_dir does not exist and cannot be created without sudo"
  fi
fi

if [ -e "$target" ]; then
  old_version=$("$target" --version 2>/dev/null || echo "unknown")
  echo "Existing dynctl found ($old_version) at $target -- it will be replaced."
fi

used_sudo=0
if [ -w "$install_dir" ]; then
  mv "$tmpdir/$asset" "$target"
  chmod +x "$target"
elif command -v sudo >/dev/null 2>&1; then
  echo "Elevated permissions required to write to $install_dir" >&2
  sudo mv "$tmpdir/$asset" "$target" || die "sudo mv failed"
  sudo chmod +x "$target" || die "sudo chmod failed"
  used_sudo=1
else
  die "$install_dir is not writable and sudo is not available. Re-run as a user with write access, or set INSTALL_DIR to a writable directory."
fi

if [ "$os" = "darwin" ]; then
  if [ "$used_sudo" = "1" ]; then
    sudo xattr -d com.apple.quarantine "$target" 2>/dev/null || true
  else
    xattr -d com.apple.quarantine "$target" 2>/dev/null || true
  fi
fi

case ":$PATH:" in
  *":$install_dir:"*) ;;
  *) echo "Note: $install_dir is not on your PATH. Add it, e.g.: export PATH=\"$install_dir:\$PATH\"" >&2 ;;
esac

echo "dynctl installed to $target"
"$target" --version 2>/dev/null || true
