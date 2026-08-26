# dynctl

`dynctl` is a CLI tool to maintain and diagnose Dynamic Engine installations
on Kubernetes.

## Installation

Download the `dynctl` binary for your platform from the
[latest release](https://github.com/qlik-download/CTL-Dynamic-Engine/releases/latest),
make it executable, and move it into a directory on your `PATH`.

```bash
# macOS (Apple Silicon) example — replace the asset name for your platform
# (dynctl-darwin-amd64, dynctl-darwin-arm64, dynctl-linux-amd64, dynctl-windows-amd64.exe)
curl -LO https://github.com/qlik-download/CTL-Dynamic-Engine/releases/latest/download/dynctl-darwin-arm64
chmod +x dynctl-darwin-arm64
sudo mv dynctl-darwin-arm64 /usr/local/bin/dynctl

# Verify the installation
dynctl --version
```

Each release also publishes a `SHA256SUMS` file to verify the downloaded
binary's checksum.

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
