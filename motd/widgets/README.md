# MOTD Widgets

Host-specific custom widgets for the MOTD system.

## Structure

```
motd/widgets/
├── README.md                    # This file
└── <hostname>/                  # Host-specific widgets directory
    └── *.sh                     # Widget scripts
```

## Creating Custom Widgets

Custom widgets are bash scripts that output information in the format:

```
label:value
```

### Example Widget

Create a file like `motd/widgets/myhost/custom-widget.sh`:

```bash
#!/bin/bash
# Custom widget example

# Your logic here
my_value="some info"

# Output in format: label:value
echo "my-label:${my_value}"
```

Make it executable:

```bash
chmod +x motd/widgets/myhost/custom-widget.sh
```

### Widget Guidelines

1. **Output format**: Always output as `label:value`
2. **Exit codes**: Return 0 on success, non-zero on failure (widget will be skipped)
3. **Performance**: Keep widgets fast (< 1 second runtime recommended)
4. **Error handling**: Suppress errors to stderr to avoid cluttering MOTD
5. **Caching**: Widgets should implement their own caching if needed

### Built-in Widgets

The following widgets are built into `motd/widgets.sh`:

- **docker**: Shows Docker container stats (running/stopped/total)
  - Cache TTL: 60 seconds
  - Requires: `docker` command

## Feature Flag

Control widgets globally via:

```bash
# In ~/dotfiles/config/local_dotfiles_settings
DOTFILES_ENABLE_MOTD_WIDGETS=false
```

## Examples

### Prometheus Metrics Widget

```bash
#!/bin/bash
# motd/widgets/myhost/prometheus.sh

# Query Prometheus
if result=$(curl -s "http://localhost:9090/api/v1/query?query=up" 2>/dev/null); then
    up_count=$(echo "${result}" | jq -r '.data.result | length' 2>/dev/null)
    if [[ -n ${up_count} ]]; then
        echo "prometheus:${up_count} targets up"
        exit 0
    fi
fi

exit 1
```

### System Temperature Widget

```bash
#!/bin/bash
# motd/widgets/myhost/temp.sh

if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
    temp_millis=$(cat /sys/class/thermal/thermal_zone0/temp)
    temp_celsius=$((temp_millis / 1000))
    echo "temp:${temp_celsius}°C"
    exit 0
fi

exit 1
```
