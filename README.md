# dynctl

`dynctl` is a CLI tool to maintain and diagnose Dynamic Engine installations
on Kubernetes.

## Installation

Each release also publishes a `SHA256SUMS` file to verify the downloaded
binary's checksum.

### macOS and Linux

```bash
curl -fsSL https://raw.githubusercontent.com/qlik-download/CTL-Dynamic-Engine/main/install.sh | sh
```

Detects your OS/arch, downloads the matching release, verifies it against
`SHA256SUMS`, and installs it to `/usr/local/bin` (using `sudo` only if
needed). Override the version or install location with env vars:

```bash
curl -fsSL https://raw.githubusercontent.com/qlik-download/CTL-Dynamic-Engine/main/install.sh | DYNCTL_VERSION=v1.2.3 INSTALL_DIR="$HOME/.local/bin" sh
```

Prefer to inspect the script before running it? `curl -fsSL <url> | less`,
or download it and run `sh install.sh` yourself.

### Windows

```powershell
Invoke-WebRequest -Uri https://github.com/qlik-download/CTL-Dynamic-Engine/releases/latest/download/dynctl-windows-amd64.exe -OutFile dynctl.exe

# Move dynctl.exe to a directory on your PATH, e.g.:
Move-Item .\dynctl.exe "$env:USERPROFILE\bin\dynctl.exe"

# Verify the installation
dynctl --version
```

Once installed, keep `dynctl` up to date with `dynctl update` (see below).

## Commands

### `dynctl doctor`

Diagnoses problems with the dynamic engine installation by running a set of
read-only checks against the cluster.

```bash
# Run diagnostics and print a health report
dynctl doctor

# Run only blocker-severity checks
dynctl doctor --severity=blocker

# Restrict checks to a single category
dynctl doctor --category=cluster-prereqs
```

### `dynctl update`

Updates `dynctl` to the latest released version.

```bash
# Update dynctl to the latest released version
dynctl update
```

### `dynctl get`

Prints details about the dynamic engine in the cluster.

```bash
# Print details about the dynamic engine in the cluster
dynctl get
```

### `dynctl get environment [<id>]`

Lists the dynamic engine environments, or prints details about a specific one.

```bash
# List dynamic engine environments
dynctl get environment

# Print details about a specific environment
dynctl get environment <id>
```

### `dynctl logs`

Prints logs of running services of the dynamic engine.

```bash
# Follow logs of the dynamic engine
dynctl logs --follow
```

### `dynctl logs environment <id>`

Prints logs of running services of a dynamic engine environment.

```bash
# Print the last 100 log lines of an environment
dynctl logs environment <id> --tail 100
```

### `dynctl completion`

Generates a shell completion script.

```bash
# Generate a bash completion script
dynctl completion bash
```

## Global flags

These flags apply to all commands:

* `--kubeconfig` — Absolute path to the kubeconfig file
* `--kubecontext` — The kubecontext to use
* `--config` — Path to a `dynctl` configuration file
* `--debug` — Enables debug logging
* `--no-update-check` — Skips the once-a-day check for a newer `dynctl` version
