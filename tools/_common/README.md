# Common MCP Tools Library

Shared utilities for all MCP tools.

## Modules

### `fdf.nu` - FDF/1 Encoder

Encodes table data (lists of records) to FDF/1 format, reducing token usage by 35-55% compared to JSON.
Requires the `fdf` CLI on PATH (https://github.com/weaming/ai-box/go/fdf).

**Usage:**

```nushell
use ../_common/fdf.nu *

# Convert a table to FDF
[{id: 1, name: "Alice"}, {id: 2, name: "Bob"}] | to-fdf
# Output:
# # FDF/1 metadata; schema=name:type; |=field; ~=null; JSON quotes/escapes; i=int s=text
# @FDF1|rows=2
# id:i|name:s
# 1|Alice
# 2|Bob
```

`to-fdf` accepts tables or JSON strings (e.g. `gh --json` output) and passes
non-table input (error messages, single objects, formatted text) through unchanged.

**Functions:**

- `to-fdf`: Convert table data to FDF/1 format

**Specification:**

Based on [FDF/1 Flat Data Frame](https://github.com/weaming/ai-box/go/fdf).
