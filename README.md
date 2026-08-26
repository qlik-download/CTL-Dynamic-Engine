# dynctl

`dynctl` is a CLI tool to maintain and diagnose Dynamic Engine installations
on Kubernetes.

This repository is used to distribute `dynctl` releases. For the full
documentation, see the
[Dynamic Engine configuration guide](https://help.qlik.com/talend/en-US/dynamic-engine-configuration-guide/Cloud/using-dynctl).

## Commands

| Command | Description |
| --- | --- |
| `dynctl get` | Prints details about the dynamic engine in the cluster |
| `dynctl get environment [<id>]` | Lists the dynamic engine environments, or prints details about a specific one |
| `dynctl logs` | Prints logs of running services of the dynamic engine |
| `dynctl logs environment <id>` | Prints logs of running services of a dynamic engine environment |
| `dynctl doctor` | Diagnoses problems with the dynamic engine installation |
| `dynctl update` | Updates `dynctl` to the latest released version |
| `dynctl completion` | Generates a shell completion script |

## Global flags

These flags apply to all commands:

| Flag | Description |
| --- | --- |
| `--kubeconfig` | Absolute path to the kubeconfig file |
| `--kubecontext` | The kubecontext to use |
| `--config` | Path to a `dynctl` configuration file |
| `--debug` | Enables debug logging |
| `--no-update-check` | Skips the once-a-day check for a newer `dynctl` version |

## Usage examples

```bash
# Print details about the dynamic engine in the cluster
dynctl get

# List dynamic engine environments
dynctl get environment

# Print details about a specific environment
dynctl get environment <id>

# Follow logs of the dynamic engine
dynctl logs --follow

# Print the last 100 log lines of an environment
dynctl logs environment <id> --tail 100

# Run diagnostics and print a health report
dynctl doctor

# Run only blocker-severity checks
dynctl doctor --severity=blocker

# Update dynctl to the latest released version
dynctl update

# Generate a bash completion script
dynctl completion bash
```
