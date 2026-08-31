# Multiple Instances

You can run multiple instances with different tool sets and sandbox directories. This approach is recommended for organizing tools by domain and avoiding conflicts.

## Example Multi-Instance Setup

```yaml
# GitHub tools with repo access
nu-mcp-gh:
  command: "nu-mcp"
  args:
    - "--tools-dir=/opt/mcp-tools/gh"
    - "--add-path=/workspace/repos"

# Tmux tools with terminal access
nu-mcp-tmux:
  command: "nu-mcp"
  args:
    - "--tools-dir=/opt/mcp-tools/tmux"

# Development tools with additional paths
nu-mcp-dev:
  command: "nu-mcp"
  args:
    - "--tools-dir=/opt/mcp-tools/dev"
    - "--enable-run-nu"
    - "--add-path=/workspace/project"
```

## Benefits of Multiple Instances

- **Tool Organization**: Group related functionality (gh, tmux, development)
- **Conflict Avoidance**: Each instance provides distinct tools without name collisions
- **Security Isolation**: Different instances can have different accessible paths
- **Clear Interface**: Clients see focused tool sets rather than everything mixed together
- **Scalability**: Easy to add new tool categories without affecting existing ones

## Important Notes

The `run` tool is automatically disabled in extension mode to prevent multiple instances from providing identical generic command execution tools, which would confuse MCP clients about which instance to use.
