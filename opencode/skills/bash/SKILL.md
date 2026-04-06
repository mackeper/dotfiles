---
description: "Use when: writing a bash script"
---

# Bash script

## Template

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined var, pipe fail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Main
main() {
    log_info "Starting..."
    # Your logic here
    log_info "Done!"
}

main "$@"
```

## Resources

- https://mywiki.wooledge.org/BashPitfalls

## Tools

- `shfmt`: Shell script formatter
