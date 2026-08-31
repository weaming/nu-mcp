# nu-mcp: Model Context Protocol (MCP) Server for Nushell

This project exposes Nushell as an MCP server using the official Rust SDK (`rmcp`).

## Features
- Exposes a tool to run arbitrary Nushell commands via MCP
- **Persistent shell** - State (environment variables, aliases, definitions) is preserved between commands
- **Shell reset** - Use `reset: true` to get a clean shell when needed
- **Configurable timeout support** - Set global defaults via `MCP_NU_MCP_TIMEOUT` or per-call with `timeout_seconds` parameter
- Extensible tool system via Nushell scripts in modular directories
- Uses the official Model Context Protocol Rust SDK
- Security sandbox with intelligent path validation and caching
- Catalog of useful MCP tools for GitHub and Tmux

## Quick Start

### Core Mode (Default)
```bash
nu-mcp
```
Provides the `run` tool for executing Nushell commands in a persistent shell. Environment variables, aliases, and definitions are preserved between calls. Use `reset: true` to get a clean environment when needed.

### Extension Mode
```bash
nu-mcp --tools-dir=./tools
```
Load tools from the included catalog or your custom tool modules. Each tool is a directory with a `mod.nu` entry file.

### Hybrid Mode
```bash
nu-mcp --tools-dir=./tools --enable-run-nu
```
Combine both core command execution and extension tools.

## Available Tools

The `tools/` directory contains a growing catalog of useful MCP tools:

- **GitHub** (`tools/gh/`) - PR, workflow, and release management via gh CLI
- **Tmux** (`tools/tmux/`) - Tmux session and pane management with intelligent command execution

## Configuration

### Command Line Options
- `--tools-dir=PATH` - Directory containing tool modules
- `--enable-run-nu` - Enable generic command execution alongside tools
- `--add-path=PATH` - Add additional accessible paths (current directory always included)

### Environment Variables
- `MCP_NU_MCP_TIMEOUT` - Default timeout in seconds for tool execution (default: 300)
- `MCP_PTY_TRACE` - Set to `1` to enable PTY trace logging to `/tmp/pty_trace.log` (persistent mode only, for debugging)

### Example MCP Configuration
```yaml
nu-mcp:
  command: "nu-mcp"
  args: ["--tools-dir=./tools", "--add-path=/tmp", "--add-path=/opt/homebrew"]
  env:
    MCP_NU_MCP_TIMEOUT: "120"  # 2 minute timeout
```
Note: Current working directory is always accessible. Use `--add-path` to grant access to additional paths.

### Path Validation

The security sandbox intelligently handles path-like strings that aren't filesystem paths:

```bash
# API endpoints work without escaping sandbox
kubectl get --raw /metrics | from json
gh api /repos/owner/repo/contents/file.yml

# Path-like arguments in commands work correctly
echo "API endpoint: /api/v1/pods"
```

The sandbox uses a two-tier system (safe patterns + runtime caching) to eliminate false positives while maintaining security.

For detailed configuration options and tool development, see the [documentation](docs/).

## Safety and Destructive Operations

**IMPORTANT**: All destructive MCP tools require explicit user confirmation before execution.

Destructive tools (delete, cleanup, force operations, etc.) include explicit warnings in their descriptions:

```
DESTRUCTIVE OPERATION - ALWAYS ASK USER FOR EXPLICIT CONFIRMATION BEFORE EXECUTING.
[specific consequence]. This operation cannot be undone.
```

**Tools with destructive capabilities:**
- **gh**: `delete_release` (deletes release + binaries), `close_pr` with `delete_branch`

**LLM Agents**: These warnings instruct LLMs to ALWAYS ask for user permission before executing destructive operations. Never execute these tools without explicit user confirmation.

**Safety Modes**: Many tools implement safety modes (readonly/non-destructive/destructive) via environment variables. See individual tool READMEs for details.

## Installation

### Via Cargo

Install from a local checkout:

```sh
cargo install --path .
```

### Tools

Tools are Nushell scripts in the `tools/` directory. Point nu-mcp at them:

```sh
nu-mcp --tools-dir=./tools
```

Or copy the `tools/` directory anywhere and pass its path with `--tools-dir`.

## Development
- See [modelcontextprotocol/rust-sdk](https://github.com/modelcontextprotocol/rust-sdk) for SDK details and advanced usage.
- The code is modular and fully async.
- Tests are in `tests/filter.rs`.

## Creating Tools

Tools are modular Nushell scripts organized in directories with a `mod.nu` entry file. See [docs/tool-development.md](docs/tool-development.md) for detailed guidance.

## Security

Commands execute within a configurable directory sandbox. See [docs/security.md](docs/security.md) for detailed security considerations.

## Documentation

- [Configuration Guide](docs/configuration.md) - Setup and configuration options
- [Tool Development](docs/tool-development.md) - Creating modular tools
- [Testing](docs/testing.md) - Testing and debugging tools
- [Architecture](docs/) - Additional technical documentation
