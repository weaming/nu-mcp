# nu-mcp

MCP server that exposes Nushell as tools, built on the official Rust SDK (`rmcp`).

## Quick Start

```sh
cargo install --path .
nu-mcp                              # run/shell tools only (cwd sandbox)
nu-mcp --tools-dir=./tools          # gh + tmux tools only
nu-mcp --tools-dir=./tools --enable-run-nu   # hybrid: tools + run/shell
```

- `run` — execute Nushell commands (stateless)
- `shell` — persistent shell; state (env, aliases, definitions) survives across calls, `reset: true` for a clean one

## Tools

- **gh** (`tools/gh/`) — PR, workflow, release management via gh CLI
- **tmux** (`tools/tmux/`) — session/pane management via tmux CLI

Tools are Nushell scripts; each directory with a `mod.nu` is a tool module. Lists are returned in [FDF/1](https://github.com/weaming/ai-box/go/fdf) format (requires the `fdf` CLI on PATH).

## Configuration

```yaml
nu-mcp:
  command: "nu-mcp"
  args: ["--tools-dir=./tools", "--add-path=/tmp"]
  env:
    MCP_NU_MCP_TIMEOUT: "120"   # default timeout, seconds (default 300)
```

- `--add-path` — extra sandbox paths (cwd always included)
- `MCP_PTY_TRACE=1` — debug PTY trace to `/tmp/pty_trace.log`

## Safety

Commands run inside a directory sandbox; paths escaping it are blocked. Destructive tools (e.g. gh `delete_release`) instruct the LLM to ask for explicit confirmation first.

## Docs

- [Configuration](docs/configuration.md) · [Security](docs/security.md) · [Tool Development](docs/tool-development.md) · [Testing](docs/testing.md)
